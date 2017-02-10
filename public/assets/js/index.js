require(['./config'], function() {
	"use strict";

	require([
		'jquery', 
		'handlebars', 
		'text!templates/foo.html',
		'bootstrap'
	], function($, Handlebars, fooTemplate) {
		var $rootElement = $("div[role=main]"),
			template = Handlebars.compile(fooTemplate);

		$rootElement.append(template());

	});
});
