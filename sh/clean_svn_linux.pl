#! /usr/bin/perl

use strict;
use Cwd;
use File::Find;

my @table;
my $name;

sub clean
{
	@table = split(/\//, $File::Find::name);
	
	$name = pop @table;
	
	if($name =~ m/\.svn/)
	{
		print "$File::Find::name\n";
		system("rm -rf $name") or unlink $name;
	}
}

find(\&clean, getcwd());

print "Clean Success!\n"
