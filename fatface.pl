use strict;
use LWP::UserAgent;
my $ua=LWP::UserAgent->new;
my $home_url ='https://www.fatface.com/stores';
print('Home URL :: ',$home_url);
my %header =('Host'=>'www.fatface.com','accept'=> 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','accept-language'=>'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36','user-agent'=>'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36');

my $home_content=Get_Content($home_url,'GET','',\%header);
open fg,">Home_Content.html";
print fg $home_content;
close fg;
my $count = 1;
while($home_content =~m/<a\s*class=\"b\-find\-a\-store\-noresult__letter\-store\"\s*href=\"([^>]*?)\">([^<]*?)</igs)
{
my $link = "https://www.fatface.com/stores".$1;
my $name =$2;
print "link :: $link\n";
print "name :: $name\n";
}

$count++;
my $detail_url = 'https://www.fatface.com/stores'.$1;
print('Detail URL :: ',$detail_url);
 my %header = ('Host'=>'www.fatface.com','accept'=>'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9','accept-language'=>'en-GB,en-US;q=0.9,en;q=0.8','user-agent'=>'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.75 Safari/537.36');
my $detail_Content = Get_Content($detail_url,'GET','',\%header);

open fg,">Detail_Content_$count.html";
print fg $detail_Content;
close fg;

my ($street,$city,$pincode,$phno);
if($detail_Content=~m/(<div\s*class=\"l\-store\-locator\-details_details\">\s*<section\s*class=\"l\-store\-locator\-details_entity\">[\w\W]?<\/li>\s<\/ul>\s*<\/section>)/is)
{
	my $detail_Content= $1;
}
if($detail_Content=~m/\"streetAddress\"\:\s*\"([^\"]*?)\"/is)
{
	$street=$1;
}
if($detail_Content=~m/\"addressLocality\"\:\s*\"([^\"]*?)\"/is)
{
	$city=$1;
}
if($detail_Content=~m/\"postalCode\"\:\s*\"([^\"]*?)\">/is)
{
	$pincode=$1;
}
if($detail_Content=~m/\"telephone\"\:\s*\"([^\"]*?)\"/is)
{
	$phno=$1;
}
open fg,">>$output.txt";
print fg "$street\t$city\t$pin\t$country\t$phno\n";
close fg;


}
}
sub Get_Content($$$$)
{
my $mainurl=shift;
my $method=shift;
my $parameter=shift;
my $headers=shift;

my %headers=%$headers;

$mainurl=~s/\&amp\;/\&/igs;
my $total_debug = 0;
my $debug = 0;

home:
my $req=HTTP::Request->new($method=>"$mainurl");

if($method eq 'POST')
{
$req->content("$parameter");
}
foreach my $key(keys%headers)
{
if($headers{$key} ne '')
{
$req->header("$key"=> "$headers{$key}");
}
}
my $res=$ua->request($req);
my $code=$res->code;

print "\nCODE :: $code\n";

if($code=~m/40/is)
{
if($debug<=3)
{
$debug++;
goto home;
}
else
{
exit;
}

}
elsif($code=~m/50/is)
{
my $con = $res->content;
return $con;
}
elsif($code=~m/20/is)
{
my $con = $res->content;
return $con;
}
elsif($code=~m/30/is)
{
my $loc=$res->header('location');
$loc=decode_entities($loc);
my $loc_url=url($loc,$mainurl)->abs;
$mainurl=$loc_url;
$method='GET';
goto home;
}
}