package Notes::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';

sub form {
}

sub login {
	my $self = shift;
	my $username = $self->param('username');
	my $password = $self->param('password');
	my $user = Notes::Model::Auth->select({username => $username, password=>$password});
	if ($username && $user->{id}) {
	$self->session(user_id => $user->{id}, username => $user->{username})->redirect_to('user_show');
	} else {
	$self->flash(error => 'Wrong username/password !')->redirect_to('auth_form');
	}
}

sub logout {
	my $self = shift;
	$self->res->headers->cache_control('max-age=0, no-cache, must-revalidate, no-store');
	$self->session(user_id => '', username => '')->redirect_to('auth_form');
}

sub check {
	my $self = shift;
	$self->session('username') ? 1 : $self->redirect_to('auth_form');
}
1;