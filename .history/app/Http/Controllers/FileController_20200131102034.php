<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use PDO;
class FileController extends Controller
{
    public function CALL_FUNCTION($P_ID_FILE_CV, $P_ID_CV_DA, $P_URL_FILE, $P_ACTION)
    {
        $sql = "DECLARE
            P_ID_FILE_CV number;
            P_ID_CV_DA number;
            P_URL_FILE varchar2(200);
            P_ACTION number(1);
        BEGIN
            :result := THEM_CAPNHAT_FILE_CV(:P_ID_FILE_CV,:P_ID_CV_DA,:P_URL_FILE,:P_ACTION);
        END;";
    
        $pdo = DB::getPdo();
        $stmt = $pdo->prepare($sql);
        $stmt->bindParam(':P_ID_FILE_CV',$P_ID_FILE_CV);
        $stmt->bindParam(':P_ID_CV_DA',$P_ID_CV_DA);
        $stmt->bindParam(':P_URL_FILE',$P_URL_FILE);
        $stmt->bindParam(':P_ACTION',$P_ACTION);
        $stmt->bindParam(':result',$result, PDO::PARAM_INT);
        // return response()->json($stmt, 200);
        $stmt->execute();
        return $result;
    }

    public function store(Request $request)
    {
        if($request->hasFile('FILE_CV'))
        {
            $P_ID_CV_DA = $request->get('P_ID_CV_DA');
            $FILE_CV = $request->file('FILE_CV');
            $FILE_CV->move(public_path().'/upload/congviec/', $FILE_CV->getClientOriginalName());
            $P_URL_FILE = '/upload/congviec/'.$FILE_CV->getClientOriginalName();
            $RESULT = $this->CALL_FUNCTION(null,$P_ID_CV_DA,$P_URL_FILE,1);

            return response()->json($RESULT, 200);
        }
        return response()->json($request->file('FILE_CV'), 200);
    }

    public function show($id)
    {
        $LIST_FILE = DB::SELECT("SELECT * FROM TB_FILE_CONG_VIEC WHERE ID_CV_DA = $id");
        return response()->json([
            "success" => true,
            "message" => 'Danh sách file',
            "result" => $LIST_FILE,
            "status" => 200
        ], 200);
    }
}
