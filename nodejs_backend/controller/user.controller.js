const UserServices = require('../services/user.service');
exports.register = async (req, res, next) => {
    try {
        console.log("---req body---", req.body);
        const { account, password } = req.body;
        const duplicate = await UserServices.getUserByaccount(account);
        if (duplicate) {
            throw new Error(`UserName ${account}, Already Registered`)
        }
        const response = await UserServices.registerUser(account, password);

        res.json({ status: true, success: 'User registered successfully' });


    } catch (err) {
        console.log("---> err -->", err);
        next(err);
    }
}

exports.login = async (req, res, next) => {
    try {

        const { account, password } = req.body;

        if (!account || !password) {
            throw new Error('Parameter are not correct');
        }
        let user = await UserServices.checkUser(account);
        if (!user) {
            // throw new Error('User does not exist');
            // res.status(404).json({ status: false, error: 'User not found' });
            res.status(404).json({ status: false, error: 'Tài khoản không tồn tại' });
        }

        const isPasswordCorrect = await user.comparePassword(password);

        if (isPasswordCorrect === false) {
            // throw new Error(`Username or Password does not match`);
            // return res.status(401).json({ status: false, error: 'Username or Password does not match' });
            return res.status(401).json({ status: false, error: 'Tài khoản hoặc mật khẩu không đúng' });
        }

        // Creating Token

        let tokenData;
        console.log(user)
        tokenData = { username: user.username, role: user.role, account: user.account };

        const token = await UserServices.generateAccessToken(tokenData, "secret", "1h")
        console.log("token: " + token)
        res.status(200).json({ status: true, success: "sendData", token: token });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}