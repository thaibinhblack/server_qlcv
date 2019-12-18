<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use DB;
use Illuminate\Contracts\Validation\Validator;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function CallFunction($username, $password, $p_id_nhom, $p_display_name, $p_id_rule, $p_sdt, $p_email, $p_gt, $p_ngaysinh, $p_action, $p_avatar)
    {
        $sql = "DECLARE
            p_username varchar2(50);
            p_password varchar2(255);
            p_id_nhom number(10);
            p_display_name varchar(255);
            p_id_rule number(10);
            p_sdt varchar2(15);
            p_email varchar2(50);
            p_gt number(1);
            p_ngaysinh date;
            p_avatar char;
            p_action number(1); 
        BEGIN
            :n := THEM_TK_TB_ND(:p_username,:p_password, :p_id_nhom, :p_display_name, :p_id_rule, :p_sdt, :p_email,:p_gt, :p_ngaysinh, :p_avatar, :p_action);
        END;";
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':p_username',$username);
        $stmt->bindParam(':p_password',$password);
        $stmt->bindParam(':p_id_nhom',$p_id_nhom);
        $stmt->bindParam(':p_display_name',$p_display_name);
        $stmt->bindParam(':p_id_rule',$p_id_rule);
        $stmt->bindParam(':p_sdt',$p_sdt);
        $stmt->bindParam(':p_email',$p_email);
        $stmt->bindParam(':p_gt',$p_gt);
        $stmt->bindParam(':p_ngaysinh',$p_ngaysinh);
        $stmt->bindParam(':p_avatar',$p_avatar);
        $stmt->bindParam(':p_action',$p_action);
        $stmt->bindParam(':n',$result);
        $stmt->execute();
        return $result;
    }

    public function index(Request $request)
    {
        if($request->has('api_token'))
        {
            $users = DB::select("SELECT * from TB_NGUOI_DUNG ND, TB_NHOM NHOM where ND.id_nhom = NHOM.id_nhom");
            return response()->json($users, 200);
        }
    }
    public function giaoviec(Request $request)
    {
       if($request->has('api_token'))
       {
        //    $ID_DU_AN_KH = $request->get('ID_DU_AN_KH');
        //    if($ID_DU_AN_KH != 0)
        //    {
        //         $users = DB::SELECT("SELECT * FROM TB_NGUOI_DUNG ND where ND.id_rule > 0");
        //    }
        //    else {
        //     $users = DB::SELECT("SELECT ND.* FROM TB_NGUOI_DUNG ND, TB_CN_ND CNND WHERE ND.ID_ND = CNND.ID_ND AND CNND.ID_CN = 3");
        //    }
            if($request->has('id_du_an'))
            {
                if($request->get('id_du_an') != 'undefined')
                {
                    $id_du_an = $request->get('id_du_an');
                    $users = DB::SELECT("SELECT * FROM TB_NGUOI_DUNG ND, TB_DU_AN DA where ND.id_nd = DA.id_ql and DA.id_du_an = $id_du_an");
                    return response()->json($users, 200);
                }
                else {
                    $users = DB::SELECT("SELECT * FROM TB_NGUOI_DUNG ND where ND.id_rule > 0");
                    return response()->json($users, 200);
                }
            }
           
       }
    }
    public function token(Request $request)
    {
        if($request->has('api_token'))
        {
            $token = $request->get('api_token');    
            $users = DB::select("SELECT * from TB_NGUOI_DUNG where TOKEN_ND = '$token'");
            return response()->json($users, 200);
        }
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    public function resignter(Request $request)
    {
        // return response()->json($request->all(), 200);
        // $validate  = $this->validate($request,[
        //     'USERNAME' => 'required|max:25',
        //     'PASSWORD' => 'required',
        //     'ID_NHOM' => 'required'
        // ]);
        if($request->has('USERNAME') && $request->has('PASSWORD') && $request->has('ID_NHOM'))
        {
            // return response()->json($request->all(), 200);
            $username = $request->get('USERNAME');
            $password = Hash::make($request->get("PASSWORD"));
            $p_id_nhom = $request->get("ID_NHOM");
            $p_sdt = $request->has("SDT_ND") ? $request->get("SDT_ND") : '';
            $p_display_name = $request->get("DISPLAY_NAME");
            $p_email = $request->has("EMAIL_ND") ? $request->get("EMAIL_ND") : '';
            $p_gt = $request->has("GOITINH_ND") ? $request->get("GIOITINH_ND") : 1;
            $p_ngaysinh = $request->has("NGAY_SINH") ? $request->get("NGAY_SINH") : '';
            $p_id_rule = $request->get("P_ID_RULE");
            $result = $this->CallFunction($username, $password, $p_id_nhom, $p_display_name,  $p_id_rule, $p_sdt, $p_email, $p_gt, $p_ngaysinh, $p_avatar=null, 1);
            if($result == 1)
            {
                return response()->json([
                    'success' => true,
                    'message' => 'Đăng ký thành công',
                    'result' => $username,
                    'status' => 200
                ], 200);
            }
            return response()->json([
                'success' => false,
                'message' => 'Username đã tồn tại',
                'status' => 404
            ], 200);
        }
        return response()->json([
            'success' => false,
            'message' => 'Biến không hợp lệ',
            'status' => 400
        ], 200);
    }
    public function login(Request $request)
    {

            $username  = $request->get("USERNAME");
            $result = DB::select("SELECT PASSWORD_ND from TB_NGUOI_DUNG where USERNAME_ND = '$username'");
            if($result)
            {
                $check = Hash::check($request->get('PASSWORD'), $result[0]->password_nd);
                if($check)
                {
                    $token =  $token = Str::random(100);
                    $sql = "DECLARE  
                        p_token varchar2(200); 
                        token varchar2(200);                            
                    BEGIN                 
                        token :=UPDATE_TOKEN_ND(:p_token,:p_username);
                    END;";
                    $pdo = DB::getPdo();
                    $stmt = $pdo->prepare($sql);
                    $stmt->bindParam(':p_token',$token);
                    $stmt->bindParam(':p_username',$username);
                    // $stmt->bindParam(':token',$result_token);
                    $stmt->execute();
                    return response()->json([
                        'success' => true,
                        'message' => 'Đăng nhập thành công!',
                        'result' => $token,
                        'status' => 200
                    ], 200);
                }
            }
            else
            {
                return response()->json([
                    'success' => false,
                    'message' => 'Tài khoản không đúng!',
                    'status' => 200,
                    'result' => ''
                ], 200);
            }
           
            return response()->json([
                'success' => false,
                'message' => 'Mật khẩu không đúng!',
                'result' =>'',
                'status' => 200
            ], 200);    

       
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        //
    }

    public function info(Request $request)
    {
        if($request->has('api_token'))
        {
            $token = $request->get('api_token');
            $user = DB::select("SELECT username_nd from TB_NGUOI_DUNG where token_nd = '$token'");
            if($user[0]->username_nd == $request->get('username_nd'))
            {
                $avatar = null;
                $file = $request->file('avatar');
                $name = $file->getClientOriginalName();
                $file->move(public_path().'/upload/avatar/', $file->getClientOriginalName());
                $avatar = '/upload/avatar/'.$file->getClientOriginalName();
                $username = $request->get('username_nd');
                $password = NULL;
                $p_id_nhom = NULL;
                $p_display_name = $request->get("display_name");
                $p_id_rule = null;
                $p_sdt = $request->get("sdt_nd");
                $p_email = $request->get("email_nd");
                $p_gt = 1;
                $p_ngaysinh =  $request->get("ngay_sinh_nd");
                $result = $this->CallFunction($username, $password, $p_id_nhom, $p_display_name, $p_id_rule, $p_sdt, $p_email, $p_gt, $p_ngaysinh, $avatar, 3);
                return response()->json($avatar, 200);
            }
        }
    }

    public function update(Request $request, $id)
    {
        if($request->has('api_token'))
        {
            //check token

            // $validate  = $this->validate($request,[
            //     'USERNAME' => 'required|max:25',
            //     'ID_NHOM' => 'required'
            // ]);
            if($request->has('USERNAME') && $request->has('ID_NHOM'))
            {
                // return response()->json($request->all(), 200);
                $username = $request->get('USERNAME');
                $password = 'NULL';
                $p_id_nhom = $request->get("ID_NHOM");
                $p_display_name = $request->get("DISPLAY_NAME");
                $p_id_rule = $request->get("P_ID_RULE");
                $p_sdt = $request->has("SDT_ND") == TRUE ? $request->get("SDT_ND") : 'NULL';
                $p_email = $request->has("EMAIL_ND") == TRUE ? $request->get("EMAIL_ND") : 'NULL';
                $p_gt = $request->has("GOITINH_ND") == true ? $request->get("GOITINH_ND") : 1;
                $p_ngaysinh = $request->has("NGAY_SINH") == TRUE ? $request->get("NGAY_SINH") : 'NULL';
                $result = $this->CallFunction($username, $password, $p_id_nhom, $p_display_name, $p_id_rule, $p_sdt, $p_email, $p_gt, $p_ngaysinh, $p_avatar =null, 2);
                if($result == 2)
                {
                    return response()->json([
                        'success' => true,
                        'message' => 'Cập nhật thành công',
                        'result' => $username,
                        'status' => 200
                    ], 200);
                }
                return response()->json([
                    'success' => false,
                    'message' => 'Cập nhật thất bại',
                    'status' => 404
                ], 200);
            }
            return response()->json([
                'success' => false,
                'message' => 'Biến không hợp lệ',
                'status' => 400
            ], 200);
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
}
