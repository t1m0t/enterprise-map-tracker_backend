import { Context } from "hono";
import { TTileUrlParams } from "../../types";
import { paramsTileQuerySchema } from "../schemas/tiles";
import { type } from "arktype";

export function validateTileUrlParams(val: TTileUrlParams, c: Context) {
	console.debug("validating: ", val);
	const parsed = paramsTileQuerySchema(val);
	if (parsed instanceof type.errors) {
		// hover out.summary to see validation errors
		console.error(parsed.summary);
		return c.text("Invalid url params", 401);
	} else {
		return parsed;
	}
}

export async function handleTileRequest(c: Context) {
	const { layer, z, x, y } = c.req.valid("param");

	const url = `${process.env.TILE_SERVER_BASE_URL}/${layer}/${z}/${x}/${y}.pbf`;
	console.debug("pg_tileserver url:", url);
	const upstream: Response = await fetch(url);

	const ct: string =
		upstream.headers.get("content-type") ||
		"application/vnd.mapbox-vector-tile";
	c.header("Content-Type", ct);

	// Copy cache headers too if you want
	const cacheControl = upstream.headers.get("cache-control");
	if (cacheControl) {
		c.header("Cache-Control", cacheControl);
	}

	return c.body(await upstream.arrayBuffer(), upstream.status);
}
