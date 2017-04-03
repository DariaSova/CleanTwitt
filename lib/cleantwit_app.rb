class CleanTwitApp

  def initialize(client)
    @client = client
  end

  def delete_all_tweets
    tweets_total = @client.user.statuses_count
    user_id = @client.user.id
    count = tweets_total
    puts "Total tweeets count: #{count}"

    begin
      while count > 0 do
        tweets = @client.user_timeline(user_id, {:count => 200})
        batch = tweets.length
        tweets.each do  |t|
          if @client.destroy_status(t.id)
            puts "Status #{t.id} deleted."
          end
        end
        puts "DELETED #{batch} TWEETS"
        count-=batch
        #if we can't get tweets
        break if batch==0
      end
    end
  rescue Exception => e
    puts "Opps..something went wrong #{e}!"
  end
end
