const UserModel = require("../models/user.model");
const jwt = require("jsonwebtoken");

class UserServices{
 
    static async registerUser(account,password){
        try{
                console.log("-----Account --- Password-----",account,password);
                
                const createUser = new UserModel({account,password});
                return await createUser.save();
        }catch(err){
            throw err;
        }
    }

    static async getUserByAccount(account){
        try{
            return await UserModel.findOne({account});
        }catch(err){
            console.log(err);
        }
    }

    static async checkUser(account){
        try {
            return await UserModel.findOne({account});
        } catch (error) {
            throw error;
        }
    }

    static async generateAccessToken(tokenData,JWTSecret_Key,JWT_EXPIRE){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
}

module.exports = UserServices;