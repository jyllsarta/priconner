# load env
source ~/.bash_profile

# code update
cd ~/priconner
git pull
cd masterdata/
git pull
cd ~/priconner/public/images/
git pull

# migrate
rails db:ridgepole:apply

# seed
RAILS_ENV=production bin/rails db:seed

# precompile asset
bundle exec rake assets:precompile

# run server
sudo SECRET_KEY_BASE=$SECRET_KEY_BASE PORT=80 RAILS_ENV=production bin/rails s
