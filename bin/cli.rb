class Cli

  def poseidon
    puts "Yo, dawg, what yo email be?"
    email = gets.chomp
    user_id = User.select("id").where("email = ?", email).pluck(:id).first

    puts "What do you want to do?"
    puts "0. Create shortened URL"
    puts "1. Visit shortened URL"
    choice = gets.chomp

    case choice
    when "0"
      puts "Type in your long url:"
      long_url = gets.chomp
      short_url = ShortenedUrl.random_code
      puts "Short URL is: #{short_url}"

      ShortenedUrl.create!(
        long_url: long_url,
        short_url: short_url,
        user_id: user_id
      )
    when "1"
      puts "Type in the shortened URL: "
      short_url = gets.chomp
      website = ShortenedUrl.select("long_url").where("short_url = ?", short_url).pluck(:long_url).first
      puts "Launching #{website}..."
      Launchy.open(website)
    end

  end

end

Cli.new.poseidon
