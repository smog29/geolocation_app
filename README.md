# README

### About
Application to store geolocation data based on IP or URL.

### How to run the application:
* Get IPStack API key: https://ipstack.com/
* Generate Master Key:
```bash
rm config/credentials.yml.enc
rails credentials:edit
```
* Open config/master.key

* Add secrets to .env:
```bash
POSTGRES_HOST=localhost
POSTGRES_DB=<db_name>
POSTGRES_USER=<db_user>
POSTGRES_PASSWORD=<db_password>
RAILS_MASTER_KEY=<generated_master_key>
IPSTACK_API_KEY=<IPSTACK_API_KEY>
RAILS_ENV=development # development or production
```
* Run the containers:
```bash
docker-compose build
docker-compose up
```

* Generate test data:
```bash
docker exec -it <container_id> bundle exec rails db:seed
```

### Running the API:
The API operates using JSON

* List geolocations:
```bash
get http://localhost:3000/api/v1/geolocations/
```

* Add geolocation:
```bash
post http://localhost:3000/api/v1/geolocations/
{
  "address": "www.wp.pl"
}
```
address could be a url or an IP address in all requests:
```bash
post http://localhost:3000/api/v1/geolocations/
{
  "address": "212.77.98.9"
}
```
* Show geolocation (from db):
```bash
get http://localhost:3000/api/v1/geolocations/find
{
  "address": "www.wp.pl"
}
```

* Update geolocation:
```bash
put http://localhost:3000/api/v1/geolocations/update
{
  "address": "www.wp.pl"
}
```

* Delete geolocation:
```bash
delete http://localhost:3000/api/v1/geolocations/delete
{
  "address": "www.wp.pl"
}
```
