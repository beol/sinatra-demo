require.config({
	paths: {
		jquery: "//code.jquery.com/jquery-1.12.4.min",
		bootstrap: "//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min",
		text: "//cdnjs.cloudflare.com/ajax/libs/require-text/2.0.12/text.min",
		handlebars: "//cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.0.5/handlebars.amd.min"
	},
	shim: {
		bootstrap: {
			deps: ['jquery']
		}
	}
});
