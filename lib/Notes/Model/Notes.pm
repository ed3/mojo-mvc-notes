package Notes::Model::Notes;

use DBI;
use Carp qw/croak/;
use Mojo::Log;
my $log = Mojo::Log->new;

my $DB;

sub init {
	my ($class, $config) = @_;
	croak "No connection!" unless $config && $config->{dsn};
	unless ( $DB ) {
		$DB = DBI->connect(@$config{qw/dsn user password/}, {RaiseError => 1,sqlite_unicode => 1});
		unless ( eval {$DB->prepare('select count(*) from notes')} ) {
		croak "Missing table!"
		}
	}
	return $DB;
}
sub db {
	return $DB if $DB;
	croak "You should init db first!";
}
sub select {
	my ($class,$self) = @_;
	my $select = $class->db->prepare("select * from notes".($self->{id} ? " where id=".$self->{id} : ""));
	$select->execute();
	my $data = $select->fetchall_arrayref;
	return $data;
}
sub insert {
	my ($class,$self) = @_;
	my $ins = $class->db->prepare("INSERT INTO notes(user_id,date,text) VALUES(?,?,?);");
	$ins->execute($self->{user_id},$self->{date},$self->{text});
	return $class->db->last_insert_id("","","notes","");
}
sub update {
	my ($class,$self) = @_;
	my $upd = $class->db->prepare("UPDATE notes SET text=? WHERE id=?");
	$upd->execute($self->{text},$self->{id});
	
	my $select = $class->db->prepare("select * from notes where id=?");
	$select->execute($self->{id});
	my $data = $select->fetchall_arrayref;
	return $data;
}
sub delete {
	my ($class,$self) = @_;
	my $del = $class->db->prepare("DELETE FROM notes WHERE user_id=? AND id=?");
	$del->execute($self->{user_id},$self->{id});
	return $self->{id};
}
1;