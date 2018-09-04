package Notes::Model::Auth;

use DBI;
use Carp qw/croak/;
use Mojo::Date;

my $DB;
sub init {
	my ($class, $config) = @_;
	croak "No connection!" unless $config && $config->{dsn};
	unless ( $DB ) {
		$DB = DBI->connect(@$config{qw/dsn user password/}, {RaiseError => 1,sqlite_unicode => 1});
		unless ( eval {$DB->prepare('select count(*) from users')} ) {
		$class->create_schema();
		}
	}
	return $DB;
}

sub db {
	return $DB if $DB;
	croak "You should init db first!";
}

sub create_schema {
my $class = shift;
$class->db->do("CREATE TABLE users (id INTEGER PRIMARY KEY,username VARCHAR(50),password VARCHAR(50),email VARCHAR(128));");
$class->db->do("CREATE TABLE notes (id INTEGER PRIMARY KEY,user_id INT(5),text TEXT,date DATE);");
$class->db->do("INSERT INTO users(username, password) VALUES('ed', 'ed');");
$class->db->do("INSERT INTO notes(user_id, text, date) VALUES(1, 'text1', '".Mojo::Date->new()->to_datetime."');");
$class->db->do("INSERT INTO notes(user_id, text, date) VALUES(1, 'text2', '".Mojo::Date->new()->to_datetime."');");
}

sub select {
	my ($class,$self) = @_;
	my $select = $class->db->prepare("select * from users where username=? AND password=?;");
	$select->execute($self->{username},$self->{password});
	my $data = $select->fetchrow_hashref;
	return $data;
}
1;