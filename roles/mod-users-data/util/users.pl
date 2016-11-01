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

my $faker = Data::Faker->new();
for (my $i = 0; $i < $users; $i++) {
  my $user = {
              username => $faker->username(),
              id => uuid(),
              active => JSON::true,
              type => 'patron',
              patron_group => 'on_campus',
              meta => {
                       creation_date => $faker->sqldate(),
                       last_login_date => $faker->sqldate()
                      },
              personal => {
                           full_name => $faker->name(),
                           email_primary => $faker->email(),
                           email_alternate => $faker->email()
                          }
             };
  open(OUT,">User" . sprintf("%03d",$i) . ".json");
  print OUT to_json($user, { pretty => 1 }) . "\n";
  close(OUT);
}

exit;               

