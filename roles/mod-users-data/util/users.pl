# build a users collection with fake data
use strict;
use warnings;
use Data::Faker;
use UUID qw /uuid/;
use JSON;

my $users;
if ($ARGV[0]) {
  $users = $ARGV[0];
} else {
  $users = 20;
}
my $start;
if ($ARGV[1]) {
  $start = $ARGV[1];
} else {
  $start = 0;
}

my $faker = Data::Faker->new();
my $common_last_name = $faker->last_name();

for (my $i = $start; $i < $users + $start; $i++) {
  my $user = {
              username => $faker->username(),
              id => uuid(),
              active => (rand(1) > 0.3 ? JSON::true : JSON::false),
              type => 'patron',
              meta => {
                       creation_date => $faker->sqldate(),
                       last_login_date => $faker->sqldate()
                      },
              personal => {
                           first_name => $faker->first_name(),
                           last_name => (rand(1) > 0.3 ?
					 $faker->last_name() :
					 $common_last_name),
                           email => $faker->email()
                          }
             };
  open(OUT,">User" . sprintf("%03d",$i) . ".json");
  print OUT to_json($user, { pretty => 1 }) . "\n";
  close(OUT);
}

exit;

