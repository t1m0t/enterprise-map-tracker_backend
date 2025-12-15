import { betterAuth } from "better-auth";
import { SQL } from "bun";
import { twoFactor } from "better-auth/plugins";

const dbUrl = process.env.DB_URL_AUTH;

const envData = {
	dbParams: {
		maxPoolCon: parseInt(process.env.DB_MAX_POOL_CON || "10"),
		idleTimeout: parseInt(process.env.DB_IDLE_TIMEOUT || "60000"),
		conMaxLifetime: parseInt(process.env.DB_CON_MAX_LIFETIME || "300000"),
		conTimeout: parseInt(process.env.DB_CON_TIMEOUT || "5000"),
		tlsEnabled: process.env.DATABASE_TLS_ENABLED === "true",
	},
};

export const auth = betterAuth({
	database: new SQL(dbUrl, {
		max: envData.dbParams.maxPoolCon,
		idleTimeout: envData.dbParams.idleTimeout,
		maxLifetime: envData.dbParams.conMaxLifetime,
		connectionTimeout: envData.dbParams.conTimeout,
		tls: envData.dbParams.tlsEnabled,
	}),
	emailAndPassword: {
		enabled: true,
	},
	appName: process.env.APP_NAME,
	plugins: [
		twoFactor({
			issuer: process.env.APP_NAME || "MyApp",
		}),
	],
});
