require(['./config'], function() {
	"use strict";

	alert("Loaded!");

	require([
		'jquery', 
		'handlebars', 
		'text!templates/foo.html',
		'bootstrap'
	], function($, Handlebars, fooTemplate) {
		alert("Loaded inner require!");

		var $rootElement = $("div[role=main]"),
			template = Handlebars.compile(fooTemplate);

		$rootElement.append(template());

	});
});
