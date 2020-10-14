const {Given, When, Then} = require('cucumber');
const {client} = require('nightwatch-api');
const fetch = require('node-fetch');
const assert = require('assert');
let response;
let Login = {};

Given('the administrator has logged in using the webUI', async function () {
	await client.page.loginPage().navigate().waitForLoginPage();
	await client.page.loginPage().userLogsInWithUsernameAndPassword(client.globals.adminUsername, client.globals.adminPassword);
	return client.page.loginPage().userIsLoggedIn(client.globals.adminUsername);
});

Given('the administrator has browsed to the new users page', function () {
	return client.page.homePage().browsedToNewUserPage();
});

When('the admin creates user with following details', function (datatable) {
	return client.page.addUsersPage().adminCreatesUser(datatable);
});

Then('new user {string} should be created', function (lastname) {
	return client.page.addUsersPage().newUserShouldBeCreated(lastname);
});

Then('message {string} should be displayed in the webUI', function (message) {
	return client.page.addUsersPage().noPermissionMessage(message);
});

Then('message {string} should not be displayed in the webUI', function (message) {
	return client.page.addUsersPage().noPermissionDefinedMessageNotShown(message);
});

Then('new user {string} should not be created', function (lastname) {
	return client.page.addUsersPage().userNotCreated(lastname);
});

Given('a user has been created with following details', function (dataTable) {
	return adminHasCreatedUser(dataTable);
});

Given('the admin has created the following users', function (dataTable) {
	return adminHasCreatedUser(dataTable);
});

Given('the user with login {string} does not exist', function (login) {
	return userDoesNotExist(login);
});

When('the admin creates user with following details using API', function (dataTable) {
	return adminCreatesUserUsingApi(dataTable);
});

Then('the response status code should be {string}', function (statusCode) {
	return getStatusCode(statusCode);
});

Then('user with login {string} should exist', function (login) {
	return userShouldExist(login);
});

Then('the response message should be {string}',function(responseMessage){
	return getResponseMessage(responseMessage);
});

const createUserRequest = function (login, lastname, password) {
	const usersEndPointUrl = client.globals.backend_url + 'api/index.php/users';
	const header = {};
	header['Accept'] = 'application/json';
	header['DOLAPIKEY'] = client.globals.dolApiKey;
	header['Content-Type'] = 'application/json';
	return fetch(usersEndPointUrl, {
		method: 'POST',
		headers: header,
		body: JSON.stringify(
			{
				login: login,
				lastname: lastname,
				pass: password
			}
		)
	});
};

const adminHasCreatedUser = async function (dataTable) {
	const userDetails = dataTable.hashes();
	for (const user of userDetails) {
		await createUserRequest(user['login'], user['last name'], user['password'])
			.then((response) => {
				if (response.status < 200 || response.status >= 400) {
					throw new Error('Failed to create user: ' + user['login'] +
						' ' + response.statusText);
				}
				return response.text();
			});
	}
};

const getUsersLogin = async function(){
	const usersEndPointUrl = client.globals.backend_url + 'api/index.php/users';
	const header = {};
	header['Accept'] = 'application/json';
	header['DOLAPIKEY'] = client.globals.dolApiKey;
	await fetch(usersEndPointUrl, {
		method: 'GET',
		headers: header
	})
		.then(async (response) => {
			const json_response = await response.json();
			for (const user of json_response) {
				Login[user.login] = user.login;
			}
		});
};

const userDoesNotExist = async function (login) {
	await getUsersLogin();
	if (login in Login) {
		Login={};
		throw new Error('User already exists');
	}
	Login={};
	return;
};

const adminCreatesUserUsingApi = function (dataTable) {
	const userDetails = dataTable.rowsHash();
	return createUserRequest(userDetails['login'], userDetails['last name'], userDetails['password'])
		.then((res) => {
			response = res;
		});


};

const userShouldExist = async function (login) {
	await getUsersLogin();
	if (login in Login) {
		Login={};
		return;
	} else {
		Login={};
		throw new Error(`User ${login} exists`);

	}
}


const getStatusCode = function (expectedStatusCode) {
	const actualStatusCode = response.status.toString();
	return assert.strictEqual(actualStatusCode, expectedStatusCode,
		`The expected status code was ${expectedStatusCode} but got ${actualStatusCode}`);
}

const getResponseMessage = async function (expectedResponseMessage) {
	const json_response = await response.json();
	const actualResponseMessage =json_response['error']['0']
	return assert.strictEqual(actualResponseMessage, expectedResponseMessage,
		`The expected response message was ${expectedResponseMessage} but got ${actualResponseMessage}`)
}
