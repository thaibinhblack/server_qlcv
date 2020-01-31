<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

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
            $FILE_CV = $request->file('FILE_CV');
            return response()->json('YES', 200);
        }
        return response()->json($request->file('FILE_CV'), 200);
    }
}
