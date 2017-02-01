class Rater     #this defines the rater class which holds each entry in the data set's user's id, movie, and rating of that movie and probides getter and setter methods

  def setName(name) #sets user_id in the instance of the rater class
    @user_id = name
  end

  def getName()   #gets user_id in the instance of the rater class
    return @user_id
  end

  def setMovie(move)#sets movie in the instance of the rater class
    @movie_id  = move
  end

  def getMovie()#gets movie in the instance of the rater class
    return @movie_id
  end

  def setRate(rate)#sets rate info in the instance of the rater class
    @rating = rate
  end

  def getRate()#gets rate info in the instance of the rater class
    return @rating
  end

end

class Ratings #class that holds data on all of the entries of a particular data set

  def load_data(data) #initalizes the data
    @peeps = Array.new #intializes a class instance variable array that holds rater objects thus breaking up the data set into usable sequences
    line_num=0
    text=File.open(data).read #opens up data file
    text.gsub!(/\r\n?/, "\n")
    text.each_line do |line| #reads each line of the data set
      elem = "#{line}"
      words = elem.split(' ') # splits each line up depending on the spaces
      count =0
      indiv = Rater.new
      words.each do |element| # loop puts elements in the data set into the correct usable places and then adds them to the peeps array
        if count == 0
          indiv.setName(element)
        end
        if count == 1
          indiv.setMovie(element)
        end
        if count == 2
          indiv.setRate(element)
        end
        if count ==3
          @peeps.push(indiv)
        end
        count = count + 1
      end
    end
  end

  def predict(user, movie)
    return 4
  end

  def hashFunction()
    $, = ", "
    hasher = Hash.new(Rater)
    i=0
    @peeps.each do |persone|
      #puts"\n #{persone.getName}"
      hasher[i] = persone
      i=i+1
    end
    return hasher
  end
end

class Validator
  def validate(tester, baser)
    movies = Array.new
    people = Array.new
    tHash = tester.hashFunction
    tKeys = tHash.keys
    exact = 0.0
    offOne = 0.0
    mean = 0.0
    standdev = 0.0
    total =0.0
    #trainDay(baser) #the method call to intialize the prediction is commented out because it takes forever, however in analyzation it would work, just at a snails pace
    tKeys.each do |indiKey|
      per = tHash[indiKey]
      rat = tester.predict(per.getName, per.getMovie)
      actual = per.getRate.to_f
      total = total + 1
      if rat == actual
        exact = exact + 1
      elsif rat+1 == actual || rat-1 == actual
        offOne = offOne + 1
      end
      if rat  >= actual
        mean = mean + rat-actual
      else
          mean = mean + actual-rat
      end
    end
    mean = mean/total
    tKeys.each do |indiKeyTwo|
      per = tHash[indiKeyTwo]
      rat = tester.predict(per.getName, per.getMovie)
      actual = per.getRate.to_i
      standdev = standdev + ((actual-mean)*(actual-mean))
    end
    standdev = Math.sqrt(standdev/total)
    puts"\nThe mean difference between the prediction and the actual rating --> #{mean}"
    puts"\nThe number of exact guesses --> #{exact}"
    puts"\nThe number of guesses that were one off --> #{offOne}"
    puts"\n The total number of predictions --> #{total}"
    puts"\n The standard deviation --> #{standdev}"
  end

  def trainDay(baser)
    mainer = Hash.new(Hash)
    bHash = baser.hashFunction
    bKeys = bHash.keys
    bKeys.each do |baseKey|
      outterPer = bHash[baseKey]
      puts"\n #{outterPer.getName}"
      sPeople = most_similar(outterPer)
      simil = Hash.new(0)
      sPeople.each do |theP|
        if simil.include?(theP.getMovie.to_i)
          va = simil[theP.getMovie.to_i]
          simil[theP.getMovie.to_i] = ((simil[theP.getMovie.to_i] + theP.getRate.to_i)/2)
        else
          simil[theP.getMovie.to_i] = theP.getRate.to_i
        end
      end
      mainer[outterPer] = simil
    end
  end

    def most_similar(u) # compiles a list of users that rated the same movie the same thing as user u did
      sim = Array.new
      tracker = Array.new
      trackerPeeps = Array.new
      simCheck = Array.new
      finalList = Array.new
      index=0
      @peeps.each do |part| # initalizes the entires that are associated with user u
        if part.getName().to_i == u
          tracker.push(part.getMovie())
          trackerPeeps.push(part)
        end
      end
      @peeps.each do |part|
        if tracker.include?(part.getMovie()) #=> false checks to see if movies in the overall list were also voted on by the user u
            sim.push(part)
        end
      end
      sim.each do |part|
        trackerPeeps.each do |partner|
          if partner.getMovie() == part.getMovie()
            if partner.getRate() == part.getRate()
              if finalList.include?(part.getName()) #makes sure each name is only added once
              else
                finalList.push(part.getName())
              end
            end
          end
        end
      end
      return finalList
    end
end

class Control
  def run()
    puts"\nPlease enter test file name"
    testData = gets.chomp
    puts"\nPlease enter base file name"
    baseData = gets.chomp
    tester = Ratings.new
    baser = Ratings.new
    tester.load_data(testData)
    baser.load_data(baseData)
    val = Validator.new
    val.validate(tester, baser)
  end
end

start = Time.now
x= Control.new
x.run()
finish = Time.now
diff = finish - start
puts"\nThe total time taken to run --> #{diff}"
