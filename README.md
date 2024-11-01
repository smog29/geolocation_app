# README

### How to run the application:
* Generate RAILS_MASTER_KEY:
```bash
rails credentials:edit
```
* Open config/master.key

* Add secrets to .env:
```bash
POSTGRES_HOST=db # To connect to the image
POSTGRES_DB=<db_name>
POSTGRES_USER=<db_user>
POSTGRES_PASSWORD=<db_password>
RAILS_MASTER_KEY=<generated_master_key>
IPSTACK_API_KEY=<IPSTACK_API_KEY>
RAILS_ENV=production
```
* Run the containers:
```bash
docker-compose up build
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
get http://localhost:3000/geolocations/
```

* Add geolocation:
```bash
post http://localhost:3000/geolocations/
{
	"address": "www.wp.pl"
}
```
address could be a url or an IP address in all requests:
```bash
post http://localhost:3000/geolocations/
{
  "address": "212.77.98.9"
}
```
* Show geolocation:
```bash
get http://localhost:3000/geolocations/find
{
  "address": "www.wp.pl"
}
```

* Update geolocation:
```bash
put http://localhost:3000/geolocations/update
{
  "address": "www.wp.pl"
}
```

* Delete geolocation:
```bash
delete http://localhost:3000/geolocations/delete
{
  "address": "www.wp.pl"
}
```