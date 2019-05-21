echo "# load env"
source ~/.bash_profile

echo "# code update"
cd ~/priconner
git pull
cd masterdata/
git pull
cd ~/priconner/public/images/
git pull

echo "# migrate"
RAILS_ENV=production rails db:ridgepole:apply

echo "# seed"
RAILS_ENV=production rails db:seed

echo "# precompile asset"
bundle exec rake assets:precompile

echo "# run server"
sudo SECRET_KEY_BASE=$SECRET_KEY_BASE PORT=80 RAILS_ENV=production rails s
