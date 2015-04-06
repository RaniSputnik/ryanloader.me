
// Set all the targets of the links to open in a new tab
$("#links-wrapper a").each(function(index){
	this.target="_blank";
});

// Load the latest blog post
var $blogData = $("#blog-data");
$blogData.rss("http://0nf0rm.blogspot.com/feeds/posts/default?alt=rss", {
    limit: 5,
    layoutTemplate: '<dl class="dl-horizontal">{entries}</dl>',
    entryTemplate: '<dt><a href="{url}">{title} - {date}</a></dt><dd>{shortBody}</dd>',
    onData: function(){
    	$('#blog-loading').remove();
    },
    error: function(){
    	$blogData.empty().html('Sorry, no blog today. You could try <a href="http://blog.ryanloader.me" target="_blank">taking a more direct route.</a>');
    },

}).show();

