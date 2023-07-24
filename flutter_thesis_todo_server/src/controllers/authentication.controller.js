const jwt = require("jsonwebtoken");
const models = require("../models");
const argon2 = require("argon2");
const {errorHandler, withTransaction} = require("../utils");
const {HttpError} = require("../error");


const register = errorHandler(withTransaction(async (req, res, session) => {
    const user = models.User({
        username: req.body.username,
        password: await argon2.hash(req.body.password)
    });
    const userRefreshToken = models.RefreshToken({
        owner: user.id
    });

    await user.save({session});
    await userRefreshToken.save({session});

    const refreshToken = createRefreshToken(user.id, userRefreshToken.id);
    const accessToken = createAccessToken(user.id);

    return {
        id: user.id,
        accessToken,
        refreshToken
    };
}));

const login = errorHandler(withTransaction(async (req, res, session) => {
    const user = await models.User
        .findOne({username: req.body.username})
        .select('+password')
        .exec();
    if (!user) {
        throw new HttpError(401, 'Login Fehlgeschlagen');
    }
    await verifyPassword(user.password, req.body.password);

    const userRefreshToken = models.RefreshToken({
        owner: user.id
    });

    await userRefreshToken.save({session});

    const refreshToken = createRefreshToken(user.id, userRefreshToken.id);
    const accessToken = createAccessToken(user.id);

    return {
        id: user.id,
        accessToken,
        refreshToken
    };
}));

const newRefreshToken = errorHandler(withTransaction(async (req, res, session) => {
    const currentRefreshToken = await validateRefreshToken(req.body.refreshToken);
    const userRefreshToken = models.RefreshToken({
        owner: currentRefreshToken.userId
    });

    await userRefreshToken.save({session});
    await models.RefreshToken.deleteOne({_id: currentRefreshToken.tokenId}, {session});

    const refreshToken = createRefreshToken(currentRefreshToken.userId, userRefreshToken.id);
    const accessToken = createAccessToken(currentRefreshToken.userId);

    return {
        id: currentRefreshToken.userId,
        accessToken,
        refreshToken
    };
}));

const newAccessToken = errorHandler(async (req, res) => {
    const refreshToken = await validateRefreshToken(req.body.refreshToken);
    const accessToken = createAccessToken(refreshToken.userId);

    return {
        id: refreshToken.userId,
        accessToken,
        refreshToken: req.body.refreshToken
    };
});

const logout = errorHandler(withTransaction(async (req, res, session) => {
    const refreshToken = await validateRefreshToken(req.body.refreshToken);
    await models.RefreshToken.deleteOne({_id: refreshToken.tokenId}, {session});
    return {success: true};
}));


function createAccessToken(userId) {
    return jwt.sign({
        userId: userId
    }, process.env.ACCESS_TOKEN_SECRET, {
       expiresIn: '10m'
    });
}

function createRefreshToken(userId, refreshTokenId) {
    return jwt.sign({
        userId: userId,
        tokenId: refreshTokenId
    }, process.env.REFRESH_TOKEN_SECRET, {
        expiresIn: '30d'
    });
}

const verifyPassword = async (hashedPassword, rawPassword) => {
    if (await argon2.verify(hashedPassword, rawPassword)) {
        // password matches
    } else {
        throw new HttpError(401, 'Falsche Benutzerdaten');
    }
};

const validateRefreshToken = async (token) => {
    const decodeToken = () => {
        try {
            return jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);
        } catch(err) {
            // err
            throw new HttpError(401, 'Unauthorised');
        }
    }

    const decodedToken = decodeToken();
    const tokenExists = await models.RefreshToken.exists({_id: decodedToken.tokenId, owner: decodedToken.userId});
    if (tokenExists) {
        return decodedToken;
    } else {
        throw new HttpError(401, 'Unauthorised');
    }
};

module.exports = {
    register,
    login,
    newRefreshToken,
    newAccessToken,
    logout
};