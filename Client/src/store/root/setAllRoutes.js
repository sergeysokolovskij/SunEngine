import VueRouter from "vue-router";

import { consoleInit, router } from "sun";
import { routes } from "sun";
import { pageNotFoundRoute } from "sun";
import { routeHasAccess } from "sun";

// Action
export default async function(context) {
	const routesFromCategories = await context.dispatch(
		"makeRoutesFromCategories"
	);
	const routesFromSections = await context.dispatch(
		"makeRoutesFromSections"
	);

	const allRoutes = [
		...routes,
		...routesFromCategories,
		...routesFromSections,
		...pageNotFoundRoute
	];
	
	if(config.Global.HomePageRedirect) {
		const homeRoute = allRoutes.find(x => x.name === "Home");
		if(homeRoute)
			homeRoute.redirect = config.Global.HomePageRedirect;
	}

	const userRoutes = allRoutes.filter(x => routeHasAccess(x));

	const tmpRouter = new VueRouter({
		mode: "history",
		routes: userRoutes
	});

	router.matcher = tmpRouter.matcher;

	console.info(
		"%cRoutes registered",
		consoleInit,
		config.Dev.LogInitExtended ? userRoutes : ""
	);
}
