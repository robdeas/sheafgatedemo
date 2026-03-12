import { LOGIN_UUID, getPassword } from '$lib/sheafgate/auth';

/** @type {import('./$types').PageServerLoad} */
export async function load() {
    return {
        uuid: LOGIN_UUID,
        password: getPassword()
    };
}