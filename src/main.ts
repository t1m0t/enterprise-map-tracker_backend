import { Hono } from "hono";
import { validator } from "hono/validator";
import { handleTileRequest, validateTileUrlParams } from "./services/tiles";

const app = new Hono();

app.get(
	"/tiles/:layer/:z/:x/:y",
	validator("param", validateTileUrlParams),
	handleTileRequest,
);

export default {
	port: 3030,
	fetch: app.fetch,
};
