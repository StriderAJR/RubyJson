module JsonDate
  #
  # Class used to convert Ruby DateTime into Json date
  #

    def self.ToMillisec(datetime)
      if datetime.class == Date
        jsonDateTime = DateToDateTime(datetime)
      elsif datetime.class == Time
        jsonDateTime = TimeToDateTime(datetime)
      else
        jsonDateTime = datetime
      end

      DateTimeMillisec(jsonDateTime)
    end

    private

    def self.DateTimeMillisec(datetime)
      datetime.strftime("%Q%z").to_s
    end

    def self.DateToDateTime(date)
      DateTime.parse(date.to_s)
    end

    def self.TimeToDateTime(time)
      DateTime.parse(time.to_s)
    end
end