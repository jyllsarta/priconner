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

echo "# run server"
#sudo SECRET_KEY_BASE=$SECRET_KEY_BASE PORT=80 RAILS_ENV=production rails s
SECRET_KEY_BASE=$SECRET_KEY_BASE PORT=80 SSL_ENABLED=y RAILS_ENV=production bundle exec pumactl start
