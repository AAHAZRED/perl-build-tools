use strict;
use warnings;

use File::Spec::Functions;
use File::Path;
use File::Find;
use FindBin;

system("make distdir") == 0 or die;
my @Entries;
foreach my $e (<*-*>) {
  next unless -d $e;
  next unless $e =~ /\w+(?:-\w+)*-v?\d+(?:\.\d+){1,2}$/;
  push(@Entries, $e);
}
if (!@Entries) {
  die("No matching directories");
} elsif (@Entries > 1) {
  die("Found multiple matching directories: @Entries");
}
my $DistVName = $Entries[0];
my $Filter = catfile($FindBin::Bin, 'pm_filter_simple.pl');
find({ no_chdir => 1,
       wanted   => sub { if (/\.pm$/ && -f $_) { system("perl $Filter $_") == 0 or die;} }
     },
     catdir($DistVName, 'lib'));
system("tar cvf $DistVName") == 0 or die;
rmtree($DistVName);
system("gzip -9f $DistVName.tar") == 0 or die;
print("Created $DistVName.tar.gz");


__END__


=pod


=head1 NAME

mkdist.pl - EXPERIMENTAL - DO NOT USE


=head1 SYNOPSIS


=head1 DESCRIPTION



=cut
