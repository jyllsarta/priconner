echo "# load env"
source ~/.zshrc

echo "# code update"
git reset --hard
git pull
cd masterdata/
git reset --hard
git pull
cd ../public/images/
git reset --hard
git pull
cd ../../

echo "# migrate"
rails db:ridgepole:apply

echo "# seed"
rails db:seed
