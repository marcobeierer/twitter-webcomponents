<timeline>
	<ul>
		<li each={ tweet, i in tweets }><raw content="{ tweet }" /></li>
	</ul>

	<script>
		var self = this;

		self.tweets = [];

		var done = function(rawTweets) {
			$.each(rawTweets, function(index, rawTweet) {
				var text = rawTweet.text;

				// replace url shortener links:
				$.each(rawTweet.entities.urls, function(index2, url) {
					var link = '<a href="' + url.expanded_url + '">' + url.display_url + '</a>';
					text = text.replace(url.url, link);
				});

				// remove image links:
				$.each(rawTweet.entities.media, function(index2, media) {
					text = text.replace(media.url, '');
				});

				self.tweets.push(text);
			});

			self.update();
		}

		var fail = function() {
			self.tweets.push('An error occurred, it was not possible to load the tweets.');
		}

		$.ajax({
			method: 'GET',
			url: 'https://api.marcobeierer.com/twitter/v1/timeline',
		})
		.done(done)
		.fail(fail);
	</script>
</timeline>
