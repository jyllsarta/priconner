echo "# load env"
source ~/.bash_profile

echo "# code update"
git pull
cd masterdata/
git pull
cd ../public/images/
git pull
cd ../../

echo "# migrate"
RAILS_ENV=production rails db:ridgepole:apply

echo "# seed"
RAILS_ENV=production rails db:seed

echo "# precompile asset"
bundle exec rake assets:precompile

echo "#clear cache"
bundle exec rails r 'Rails.cache.clear'

echo "kill older server(https)"
PID=`ps ax | grep '[p]uma' | awk '{ print $1 }'`
echo "older server is ${PID}"
kill -9 ${PID}

echo "start server"
SECRET_KEY_BASE=$SECRET_KEY_BASE SSL_ENABLED=y RAILS_ENV=production bundle exec pumactl start
