<twitter-timeline>
	<ul>
		<li if={ tweets.length == 0 }>Loading tweets. Please wait a moment.</li>
		<li each={ tweet, i in tweets }><raw content="{ tweet }" /></li>
	</ul>

	<script>
		var self = this;

		self.tweets = [];
		self.count = opts.count || '0'; // 0 = infinite

		var done = function(rawTweets) {
			jQuery.each(rawTweets, function(index, rawTweet) {
				var text = rawTweet.text;

				// replace url shortener links:
				jQuery.each(rawTweet.entities.urls, function(index2, url) {
					var link = '<a href="' + url.expanded_url + '">' + url.display_url + '</a>';
					text = text.replace(url.url, link);
				});

				// remove image links:
				jQuery.each(rawTweet.entities.media, function(index2, media) {
					text = text.replace(media.url, '');
				});

				var datex = new Date(Date.parse(rawTweet.created_at.replace(/( +)/, ' UTC$1'))).toLocaleString();
				var dateHTML = '<span class="datetime">' + datex + '</span>';

				self.tweets.push(dateHTML + text);
			});

			self.update();
		}

		var fail = function() {
			self.tweets.push('An error occurred, it was not possible to load the tweets.');
			self.update();
		}

		jQuery.ajax({
			method: 'GET',
			url: 'https://api.marcobeierer.com/twitter/v1/timeline?count=' + self.count,
		})
		.done(done)
		.fail(fail);
	</script>
</twitter-timeline>
