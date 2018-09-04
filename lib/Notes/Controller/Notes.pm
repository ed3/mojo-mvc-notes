package Notes::Controller::Notes;
use base 'Mojolicious::Controller';
use Notes::Model::Notes;
use Mojo::Date;

sub index {
my $self = shift;
$self->render(notes => Notes::Model::Notes->select());
}

sub create {
my $self = shift;
my $notes_id = Notes::Model::Notes->insert({
user_id => $self->session('user_id'),
text => $self->param('text'),
date => Mojo::Date->new()->to_datetime
});
$self->render(json => Notes::Model::Notes->select({id=>$notes_id}));
}

sub update {
my $self = shift;
my $notes = Notes::Model::Notes->update({
id => $self->param('id'),
user_id => $self->session('user_id'),
text => $self->param('text')
});
$self->render(json => $notes);
}

sub delete {
my $self = shift;
my $id = Notes::Model::Notes->delete({user_id => $self->session('user_id'),id => $self->param('id')});
$self->render(json => $id);
}
1;