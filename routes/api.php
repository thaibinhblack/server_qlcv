<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/
//user
Route::get('user','UserController@index')->middleware('cors');
Route::get('user-giaoviec','UserController@giaoviec')->middleware('cors');
Route::get('user/{id}','UserController@show')->middleware('cors');
Route::post('user/{id}','UserController@update')->middleware('cors');
Route::get('token', 'UserController@token')->middleware('cors');
Route::post('resignter', 'UserController@resignter')->middleware('cors');
Route::post('info','UserController@info')->middleware('cors');
Route::post('check_password','UserController@check_password')->middleware('cors');
Route::get('thong-ke','UserController@thongke')->middleware('cors');
Route::post('login', 'UserController@login')->middleware('cors');

//function
Route::get('functions','FunctionController@index')->middleware('cors');
Route::post('function','FunctionController@store')->middleware('cors');

//function user

Route::get('function_user','FunctrionUserController@index')->middleware('cors');
Route::post('function_user','FunctrionUserController@store')->middleware('cors');

//group
Route::get('group_user', 'NhomController@index')->middleware('cors');
Route::get('group_user/{id}','NhomController@show')->middleware('cors');
Route::post('group_user', 'NhomController@store')->middleware('cors');
Route::post('group_user/{id}', 'NhomController@update')->middleware('cors');

//customers

Route::get('customers','CustomerController@index')->middleware('cors');
Route::post('customer','CustomerController@store')->middleware('cors');
Route::post('customer/{id}','CustomerController@update')->middleware('cors');
Route::post('customer_search','CustomerController@search')->middleware('cors');

//trung tâm
Route::get('trung-tam','TrungTamController@index')->middleware('cors');
Route::post('trung-tam','TrungTamController@store')->middleware('cors');

// loại dự án
Route::get('loai-du-an','LoaiDuANController@index')->middleware('cors');
Route::get('thong-ke-loai-du-an','LoaiDuANController@thongke')->middleware('cors');
Route::post('loai-du-an','LoaiDuANController@store')->middleware('cors');
Route::post('loai-du-an/{id}','LoaiDuANController@update')->middleware('cors');

// dự án
Route::get('du-an','DuAnController@index')->middleware('cors');
Route::post('du-an','DuAnController@store')->middleware('cors');
Route::post('du-an/{id}','DuAnController@update')->middleware('cors');

// dự án khách hàng
Route::get("du-an-kh",'DuAnKhachHangController@index')->middleware('cors');
Route::get("du-an-kh/{id}",'DuAnKhachHangController@show')->middleware('cors');
Route::post("du-an-kh",'DuAnKhachHangController@store')->middleware('cors');
Route::post("du-an-kh/{id}",'DuAnKhachHangController@update')->middleware('cors');
Route::get("du-an-kh-insert-delete/{id_cv_da}/{id_du_an_kh}",'DuAnKhachHangController@insert_destroy')->middleware('cors');
//trạng thái dự án khách hàng
Route::get('trang-thai-du-an-kh',"DuAnKhachHangController@index_trang_thai")->middleware('cors');
Route::post('trang-thai-du-an-kh',"DuAnKhachHangController@store_trang_thai")->middleware('cors');
Route::post('trang-thai-du-an-kh/{id}/delete','DuAnKhachHangController@destroy_trang_thai')->middleware('cors');
//thông tin dự án khách hàng
Route::get('thong-tin-duan-kh/{id_du_an_kh}','ThongTinDAKHController@show')->middleware('cors');
Route::post('thong-tin-duan-kh','ThongTinDAKHController@store')->middleware('cors');
Route::post('thong-tin-duan-kh/{id_thongtin}','ThongTinDAKHController@update')->middleware('cors');
Route::post('thong-tin-duan-kh/{id_thongtin}/delete','ThongTinDAKHController@destroy')->middleware('cors');
// nhân viên tham gia dự án
Route::get('nhanvien-da','DuAnKhachHangController@nhanvien_duan')->middleware('cors');
Route::get('quyen-nhanvien-da','DuAnKhachHangController@show_quyen_thanhvien')->middleware('cors');
Route::post('nhanvien-da','DuAnKhachHangController@themthanhvien')->middleware('cors');
Route::post('cap-nhat-quyen-thanhvien','DuAnKhachHangController@update_quyen_thanhvien')->middleware('cors');
//cong viec
Route::get('cong-viec','CongViecController@index')->middleware('cors');
Route::get('cong-viec-phan-cong','CongViecController@cong_viec_phan_cong')->middleware('cors');
Route::get('cong_viec_trong_ngay','CongViecController@cong_viec_trong_ngay')->middleware('cors');
Route::get('cong-viec-filter','CongViecController@filter')->middleware('cors');
Route::get('cong-viec-goc/{id}','CongViecController@congviecgoc')->middleware('cors');
Route::get('cong-viec-chua-phan-cong','CongViecController@cvchuaphancong')->middleware('cors');
Route::post('tham-dinh-cong-viec/{id}','CongViecController@thamdinh')->middleware('cors');
Route::post('capnhat_congviec/{id}','CongViecController@capnhat_congviec')->middleware('cors');
Route::post('cong-viec','CongViecController@store');
Route::get('cong-viec/{id}/chitietcv','CongViecController@congviec_chitiet')->middleware('cors');
Route::get('cong-viec/{id}/{id_du_an}','CongViecController@show')->middleware('cors');
Route::post('cong-viec/{id}','CongViecController@update')->middleware('cors');
Route::get('cong-viec-delete/{id}','CongViecController@destroy')->middleware('cors');
Route::get('bao-cao/{id}','CongViecController@get_baocao')->middleware('cors');
Route::post('cong-viec/{id}/baocao','CongViecController@baocao')->middleware('cors');
Route::get('cong-viec-setting/{id_setting}','CongViecController@show_setting')->middleware('cors');
Route::post('cong-viec-setting/{id_setting}','CongViecController@setting')->middleware('cors');
Route::post('cong-viec-setting-modal','CongViecController@setting_modal')->middleware('cors');
Route::get('cong-viec-setting-modal','CongViecController@show_setting_modal')->middleware('cors');
Route::get('auto-nhac-viec','CongViecController@AUTO_NHAC_VIEC')->middleware('cors');

Route::get("cong-viec-con/{ID_PARENT}",'CongViecController@lstsubtask')->middleware('cors');
Route::post("cong-viec-con",'CongViecController@subtask')->middleware('cors');

//Thẩm định công việc
Route::post('tham-dinh-list-cv','ThamDinhController@tham_dinh_cv')->middleware('cors');
Route::post('gui-tham-dinh', 'ThamDinhController@gui_tham_dinh')->middleware('cors');

//FILE CÔNG VIỆC
Route::post('file-cv','FileController@store')->middleware('cors');
Route::get('file-cv/{id}','FileController@show')->middleware('cors');
//cong việc dự án
Route::post('cong-viec-da','CongViecController@chitiet')->middleware('cors');
// loại công việc
Route::get('loai-cv','LoaiCongViecController@index')->middleware('cors');
Route::get('loai-cv/{id}','LoaiCongViecController@show')->middleware('cors');
Route::post('loai-cv','LoaiCongViecController@store')->middleware('cors');
Route::post('loai-cv/{id}','LoaiCongViecController@update')->middleware('cors');
//thống kê
Route::get('thong-ke-lcv-12-thang','ThongKeController@so_luong_lcv_12_thang')->middleware('cors');

//Lịch công tác
Route::get("lich-cong-tac",'LichCongTacController@index')->middleware('cors');
Route::post("lich-cong-tac",'LichCongTacController@store')->middleware('cors');
Route::post("lich-cong-tac/{id}",'LichCongTacController@update')->middleware('cors');

Route::get('/test','CongViecController@test')->middleware('cors');
//setting
Route::get('/setting-du-an/{id}','SettingController@show_du_an')->middleware('cors');
Route::post('/setting-du-an','SettingController@store_du_an')->middleware('cors');
Route::post('/setting-value-du-an-kh/{id}','SettingController@update_du_an')->middleware('cors');
Route::post('/setting-cai-dat-list-cv','SettingController@update_list_cv')->middleware('cors');
Route::get('/setting-cai-dat-list-cv','SettingController@show_list_cv')->middleware('cors');


Route::get('downloadExcel/{type}', 'MaatwebsiteDemoController@downloadExcel');

Route::get('/season','StudyController@season')->middleware('cors');
Route::post('/study','StudyController@store')->middleware('cors');


Route::get('/test/{id}','TestController@CONGVIEC_ID')->middleware('cors');
Route::post('/test/{id}','TestController@CONGVIEC_ID_UPDATE')->middleware('cors');

//thống kê
Route::get('/thong-ke/da-kh','ThongKeController@thongke_du_an_kh')->middleware('cors');