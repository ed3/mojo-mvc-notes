package Notes;
use Mojo::Base 'Mojolicious';
use Notes::Model::Auth;
use Notes::Model::Notes;

sub startup {
  my $self = shift;

	$self->secrets(['secret']);
	$self->mode('development');
	$self->sessions->default_expiration(3600*24*7);

	my $config = $self->plugin('JSONConfig' => { file=>'notes.json' } );

	my $r = $self->routes;
	$r->namespaces(['Notes::Controller']);

	$r->route('/')->to('auth#form')->name('auth_form');
	$r->route('/login')->via('post')->to('auth#login')->name('auth_login');
	$r->route('/logout')->to('auth#logout')->name('auth_logout');
	
	$r->route('/user')->via('get')->to('user#show')->name('user_show');
	$r->route('/register')->via('get')->to('user#form')->name('user_form');
	$r->route('/register')->via('post')->to('user#create')->name('user_create');

	my $rn = $r->under('/notes')->to('auth#check');
	$rn->route->via('get')->to('notes#index')->name('notes_show');
	$rn->route->via('post')->to('notes#create')->name('notes_create');
	$rn->route('/:id', id => qr/\d+/)->via('put')->to('notes#update')->name('notes_update');
	$rn->route('/:id', id => qr/\d+/)->via('delete')->to('notes#delete')->name('notes_delete');

	# Init Model
	my $db = {dsn => 'dbi:SQLite:dbname=' . $self->home->child('storage') . '/notes.db',user => '',password =>''};
	Notes::Model::Auth->init($config->{db} || $db);
	Notes::Model::Notes->init($config->{db} || $db);
}
1;