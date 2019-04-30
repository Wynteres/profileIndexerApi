FROM ruby:2.3.8
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /profileIndexer
WORKDIR /profileIndexer
COPY Gemfile /profileIndexer/Gemfile
COPY Gemfile.lock /profileIndexer/Gemfile.lock
RUN bundle install
COPY . /profileIndexer

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
EXPOSE 8080

# Start the main process.
CMD ["rails", "server","-p", "8080" "-b", "0.0.0.0"]