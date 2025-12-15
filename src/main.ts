import { Hono } from "hono";
import { paramsTileQuerySchema } from "./schemas/tiles";
import { validator } from "hono/validator";
import { type } from "arktype";

const app = new Hono();

app.get(
	"/tiles/:layer/:z/:x/:y",
	validator("param", (val, c) => {
		console.debug("validating: ", val);
		const parsed = paramsTileQuerySchema(val);
		if (parsed instanceof type.errors) {
			// hover out.summary to see validation errors
			console.error(parsed.summary);
			return c.text("Invalid url params", 401);
		} else {
			return parsed;
		}
	}),
	async (c) => {
		const { layer, z, x, y } = c.req.valid("param");

		const url = `${process.env.TILE_SERVER_BASE_URL}/${layer}/${z}/${x}/${y}.pbf`;
		console.debug("pg_tileserver url:", url);
		const upstream = await fetch(url);

		const ct =
			upstream.headers["content-type"] || "application/vnd.mapbox-vector-tile";
		c.header("Content-Type", ct);

		// Copy cache headers too if you want
		const cacheControl = upstream.headers["cache-control"];
		if (cacheControl) {
			c.header("Cache-Control", cacheControl);
		}

		return c.body(await upstream.arrayBuffer(), upstream.status);
	},
);

export default {
	port: 3030,
	fetch: app.fetch,
};
