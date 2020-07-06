CREATE OR REPLACE EDITIONABLE PROCEDURE "HIS_REPORTS"."BAOCAO_HOATDONGDIEUTRI_SEL" (
    p_dvtt in varchar2,
    p_tungay_s in varchar2,
    p_denngay_s in varchar2,
    p_cachlay in number,
cur OUT SYS_REFCURSOR)
IS
    p_tungay  date;
    p_denngay  date;
    v_thamso93253 varchar2(10):= HIS_MANAGER.DM_TSDV_SL_MTSO(p_dvtt,'93253');
BEGIN
    if substr(p_dvtt,1,2) = '89' then
        AGG_BC_HDDT_SEL (p_dvtt,p_tungay_s,p_denngay_s,cur);
    elsif substr(p_dvtt,1,2) = '52' or substr(p_dvtt,1,2) = '49' or v_thamso93253 = '1' then
        BDH_BAOCAO_HDDT_SEL(p_dvtt,p_tungay_s,p_denngay_s,cur);
    else
        p_tungay:=to_date(p_tungay_s, 'yyyy-mm-dd');
        p_denngay:=to_date(p_denngay_s, 'yyyy-mm-dd');
        baocao_taosl_hoatdongdieutri (p_dvtt,p_tungay,p_denngay,p_cachlay);

        delete from his_reports.baocao_hoatdongdieutri_tong where dvtt = p_dvtt ;

        insert into his_reports.baocao_hoatdongdieutri_tong(
            khoa, sogiuong,
            benhdauky, benhdauky_nu,
            benhtrongky, benhtrongky_nu,
            treem, treem_nu,
            TREEM_DUOI6, TREEM_DUOI6_NU,
            capcuu, capcuu_nu,
            songaydieutri, songaydieutri_nu,
            tuvong, tuvong_nu,
            tuvong_treem, tuvong_treem_nu,
            tuvong_truoc24gio, tuvong_truoc24gio_nu,
            TUVONG_DUOI5, TUVONG_DUOI5_NU,
            cobaohiem, cobaohiem_nu,
            benhcuoiky, benhcuoiky_nu,
            ngaybaocao, dvtt, ghichu,
            nu
        )
        select
            khoa,sogiuong, 
            benhdauky, case when nu = 0 then 0 else benhdauky end  as benhdauky_nu,
            benhtrongky, case when nu = 0 then 0 else benhtrongky end  as benhdauky_nu,
            treem, case when nu = 0 then 0 else treem end  as treem_nu,
            TREEM_DUOI6, case when nu = 0 then 0 else TREEM_DUOI6 end  as TREEM_DUOI6_NU,
            capcuu, case when nu = 0 then 0 else capcuu end  as capcuu_nu,
            songaydieutri, case when nu = 0 then 0 else songaydieutri end  as songaydieutri_nu,
            tuvong, case when nu = 0 then 0 else tuvong end  as tuvong_nu,
            tuvong_treem, case when nu = 0 then 0 else tuvong_treem end  as tuvong_treem_nu,
            tuvong_truoc24gio, case when nu = 0 then 0 else tuvong_truoc24gio end  as tuvong_truoc24gio_nu,
            TUVONG_DUOI5, case when nu = 0 then 0 else TUVONG_DUOI5 end  as TUVONG_DUOI5_NU,
            cobaohiem, case when nu = 0 then 0 else cobaohiem end  as cobaohiem_nu,
            benhcuoiky, case when nu = 0 then 0 else benhcuoiky end  as benhcuoiky_nu,
            ngaybaocao, dvtt, ghichu,
            nu
        from his_reports.baocao_hoatdongdieutri
            where dvtt = p_dvtt and trunc(ngaybaocao) between p_tungay and p_denngay;

        OPEN cur FOR
        SELECT
            a.ten_phongban khoa, c.so_giuong sogiuong,
            sum(benhdauky) as benhdauky, sum(benhdauky_nu) as benhdauky_nu,
            sum(benhtrongky) as benhtrongky, sum(benhtrongky_nu) as benhtrongky_nu,
            sum(treem) as treem, sum(treem_nu) as treem_nu, 
            sum(TREEM_DUOI6) as TREEM_DUOI6, sum(TREEM_DUOI6_NU) as TREEM_DUOI6_NU, 
            sum(capcuu) as capcuu, sum(capcuu_nu) as capcuu_nu,
            sum(songaydieutri) as songaydieutri, sum(songaydieutri_nu) as songaydieutri_nu, 
            sum(tuvong) as tuvong, sum(tuvong_nu) as tuvong_nu,
            sum(tuvong_treem) as tuvong_treem, sum(tuvong_treem_nu) as tuvong_treem_nu, 
            sum(tuvong_truoc24gio) as tuvong_truoc24gio, sum(tuvong_truoc24gio_nu) as tuvong_truoc24gio_nu,
            sum(TUVONG_DUOI5) as TUVONG_DUOI5, sum(TUVONG_DUOI5_NU) as TUVONG_DUOI5_NU,
            sum(cobaohiem) as cobaohiem, sum(cobaohiem_nu) as cobaohiem_nu,
            sum(benhcuoiky) as benhcuoiky, sum(benhcuoiky_nu) as benhcuoiky_nu, ngaybaocao, dvtt, 0 as nu,' ' as ghichu,
            0 as xtongnhapvien, 0 as xtongnhapvien_nu,
            0 as xtuoibn15, 0 as xtuoibn15_nu,
            0 as xcapcuu, 0 as xcapcuu_nu,
            0 as xcobhyt,0 as xcobhyt_nu
        FROM his_fw.dm_phongban a
        LEFT JOIN his_reports.baocao_hoatdongdieutri_tong b on a.ma_phongban = b.khoa
        LEFT JOIN phongban_sogiuong c on  a.ma_phongban= c.ma_phongban
        where dvtt = p_dvtt
            and ngaybaocao between p_tungay and p_denngay
            and a.chucnangkhamchuabenh in (2,3)
        group by a.ten_phongban, c.so_giuong, ngaybaocao, dvtt
        order by khoa
        ;
    end if;
END;

