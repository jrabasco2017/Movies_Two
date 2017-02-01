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
    bHash = baser.hashFunction
    tKeys = tHash.keys
    bKeys = bHash.keys
    exact = 0.0
    offOne = 0.0
    mean = 0.0
    standdev = 0.0
    total =0.0
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
  #  mean = mean/total
    puts"\nThe mean difference between the prediction and the actual rating - #{mean}"
    puts"\nThe number of exact guesses - #{exact}"
    puts"\nThe number of guesses that were one off - #{offOne}"
    puts"\n The total number of predictions - #{total}"
    puts"\n The standard deviation - #{standdev}"
    #bUsers = generation(bKeys, bHash, 1)
    #bMovies = generation(bKeys, bHash, 2)
    #predictionArray(bUsers,bMovies)
  end

  def predictionArray(users, movies)

  end

  def generation (keyArray, hasher, x)
    temp = Array.new
    keyArray.each do |indivKey|
      pep = hasher[indivKey]
      if x== 1
        pepName = pep.getName
      else
        pepName = pep.getMovie
      end
      if temp.include?(pepName)
        temp.push(pepName)
      end
    end
    return temp
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

x= Control.new
x.run()
