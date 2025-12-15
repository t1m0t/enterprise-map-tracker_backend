import { type } from "arktype";

export const paramsTileQuerySchema = type({
	layer: "5 < string < 150 | /[a-zA-Z0-9.]+$/ ",
	z: "0 < string.integer < 10000",
	x: "0 < string.integer < 10000",
	y: "0 < string.integer < 10000",
});
