import { Hono } from "hono";
import { validator } from "hono/validator";
import { handleTileRequest, validateTileUrlParams } from "./services/tiles";
import { auth } from "@/lib/auth";
import { authMiddleware } from "./services/auth";

const app = new Hono();

// middlewares
app.use("*", authMiddleware);

app.get(
	"/tiles/:layer/:z/:x/:y",
	validator("param", validateTileUrlParams),
	handleTileRequest,
);

app.on(["POST", "GET"], "/api/auth/*", (c) => auth.handler(c.req.raw));

export default {
	port: 3030,
	fetch: app.fetch,
};
