  CREATE OR REPLACE EDITIONABLE PROCEDURE "HIS_REPORTS"."BAOCAO_TAOSL_HOATDONGDIEUTRI" (
 p_dvtt in varchar2,
 p_tungay in date,
 p_denngay in date,
 p_cachlay in NUMBER
)
IS
   p_ngaydauky date;
   v_thamso_longan number(1) default '0';
   v_ts52090 number(1);-- BDH thêm tham số cách lấy số liệu: TGGDEV-40267
BEGIN
   begin
      select mota_thamso into v_thamso_longan FROM HIS_FW.DM_THAMSO_DONVI where dvtt=p_dvtt and ma_thamso = 820450;
      exception when no_data_found then
          v_thamso_longan:='0';
    end;

  BEGIN
      SELECT mota_thamso
      INTO   v_ts52090
      FROM   HIS_FW.DM_THAMSO_DONVI
      WHERE  dvtt = p_dvtt and ma_thamso = 52090;
      EXCEPTION WHEN no_data_found then
          v_ts52090 := 0;
    END;

   p_ngaydauky := p_tungay - 1 ;


   delete from his_reports.BAOCAO_HOATDONGDIEUTRI where dvtt = p_dvtt ;
if v_thamso_longan != 0 then
--so luong nguoi benh dau ky
INSERT INTO HIS_REPORTS.BAOCAO_HOATDONGDIEUTRI
  (KHOA,
   SOGIUONG,
   BENHDAUKY,
   BENHTRONGKY,
   TREEM,
   CAPCUU,
   SONGAYDIEUTRI,
   TUVONG,
   TUVONG_TREEM,
   TUVONG_TRUOC24GIO,
   COBAOHIEM,
   BENHCUOIKY,
   NGAYBAOCAO,
   DVTT,
   GHICHU,
   NU)

  SELECT cast(xv.khoa_xuatvien as VARCHAR2(500)),
         0 SOGIUONG,
         1 BENHDAUKY,
         0 BENHTRONGKY,
         0 TREEM,
         0 CAPCUU,
         0 SONGAYDIEUTRI,
         0 TUVONG,
         0 TUVONG_TREEM,
         0 TUVONG_TRUOC24GIO,
         CASE
           WHEN T.MUC_HUONG > 0 THEN
            1
           ELSE
            0
         END COBAOHIEM,
         0 BENHCUOIKY,
         P_DENNGAY NGAYBAOCAO,
         BA.DVTT DVTT,
         'DAUKY' GHICHU,
         CASE
           WHEN T.GIOI_TINH = 1 THEN
            0
           ELSE
            1
         END NU
    FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
    inner join his_manager.noitru_xuatvien xv on xv.stt_benhan = t.stt_benhan and
    xv.sovaovien = t.sovaovien_noi and xv.stt_dotdieutri = t.stt_dotdieutri
   WHERE T.DVTT = P_DVTT
     AND NVL(TRUNC(BA.NGAY_RAVIEN),SYSDATE) > P_NGAYDAUKY
     AND TRUNC(BA.NGAY_NHAPVIEN) <= P_NGAYDAUKY
UNION ALL

-- th?ng kê nh?p vi?n trong kho?ng th?i gan

  SELECT cast(xv.khoa_xuatvien as VARCHAR2(500)),
         0 SOGIUONG,
         0 BENHDAUKY,
         1 BENHTRONGKY,
         CASE
           WHEN BN.TUOI < 15 THEN
            1
           ELSE
            0
         END TREEM,
         CASE
           WHEN T.CAPCUU = 1 THEN
            1
           ELSE
            0
         END CAPCUU,
         0 SONGAYDIEUTRI,
         0 TUVONG,
         0 TUVONG_TREEM,
         0 TUVONG_TRUOC24GIO,
         CASE
           WHEN T.MUC_HUONG > 0 THEN
            1
           ELSE
            0
         END COBAOHIEM,
         0 BENHCUOIKY,
         P_DENNGAY NGAYBAOCAO,
         BA.DVTT DVTT,
         'TRONGKY' GHICHU,
         CASE
           WHEN T.GIOI_TINH = 1 THEN
            0
           ELSE
            1
         END NU
    FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
    INNER JOIN HIS_MANAGER.NOITRU_PHIEUTHANHTOAN PTT ON PTT.SOVAOVIEN = T.SOVAOVIEN_NOI AND PTT.SOVAOVIEN_DT=T.SOVAOVIEN_DT_NOI
    INNER JOIN HIS_PUBLIC_LIST.DM_BENH_NHAN    BN ON BA.MABENHNHAN = BN.MA_BENH_NHAN
   inner join his_manager.noitru_xuatvien xv on xv.stt_benhan = t.stt_benhan and
    xv.sovaovien = t.sovaovien_noi and xv.stt_dotdieutri = t.stt_dotdieutri
   WHERE T.DVTT = P_DVTT
   AND NVL(PTT.TT_PHIEUTHANHTOAN,0) <= 4
     AND TRUNC(decode(p_cachlay,1,ba.ngay_nhapvien,ba.ngay_ravien)) BETWEEN P_TUNGAY AND P_DENNGAY

UNION ALL

  SELECT CAST(tv.khoa_tuvong as VARCHAR2(500)),
         0 AS GIUONG,
         0 AS DAUKY,
         0 AS TRONGKY,
         0 AS TRONGKY_DUOI15,
         0 AS CAPCUU,
         0 AS SONGAY,
         1 AS TUVONG,
         CASE
           WHEN BN.TUOI < 15 THEN
            1
           ELSE
            0
         END AS TUVONG_DUOI15,
         CASE
           WHEN NGAY_RAVIEN - NGAY_NHAPVIEN <= 1 THEN
            1
           ELSE
            0
         END AS TUVONG_TRONG24H,
         0 AS COBH,
         0,
         P_DENNGAY,
         BA.DVTT,
         'TUVONG',
         CASE
           WHEN BN.GIOI_TINH = 1 THEN
            0
           ELSE
            1
         END NU
    FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
    INNER JOIN HIS_PUBLIC_LIST.DM_BENH_NHAN    BN ON BA.MABENHNHAN = BN.MA_BENH_NHAN
    inner join his_manager.noitru_tuvong tv on tv.sovaovien = t.sovaovien_noi and tv.stt_benhan = t.stt_benhan
    and tv.stt_dotdieutri = t.stt_dotdieutri
   WHERE T.DVTT = P_DVTT
     and ba.TRANG_THAI = 5
     AND TRUNC(decode(p_cachlay,1,ba.ngay_nhapvien,ba.ngay_ravien)) BETWEEN P_TUNGAY AND P_DENNGAY

UNION ALL
-- th?ng kê b?nh nhân còn nam vi?n

SELECT cast(xv.khoa_xuatvien as VARCHAR2(500)),0 as giuong,0 as dauky,0 as trongky,0 as trongky_duoi15,0 as capcuu, 0 as songay,0 as tuvong,0 as tuvong_duoi15,0 as tuvong_trong24h,0 as cobh,1 as cuoiky,p_denngay,ba.dvtt,'cuoiky',case when bn.gioi_tinh = 1 then 0 else 1 end nu
     FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
    INNER JOIN HIS_PUBLIC_LIST.DM_BENH_NHAN    BN ON BA.MABENHNHAN = BN.MA_BENH_NHAN
    inner join his_manager.noitru_xuatvien xv on xv.stt_benhan = t.stt_benhan and
    xv.sovaovien = t.sovaovien_noi and xv.stt_dotdieutri = t.stt_dotdieutri
where t.dvtt = p_dvtt
and nvl(ba.ngay_ravien,sysdate) > p_denngay
and trunc(ba.ngay_nhapvien) <= p_denngay

UNION ALL


SELECT log.maphongban,0 as giuong,0 as dauky,0 as trongky,0 as trongky_duoi15,0 as capcuu,((nvl(trunc(log.ngay_chuyendi),(trunc(ba.ngayravien))) - trunc(log.ngay_chuyenden)) + 1) as songay,0 as tuvong,0 as tuvong_duoi15,0 as tuvong_trong24h,0 as cobh,0,p_denngay,ba.dvtt,'songaydieutri',case when T.gioi_tinh = 1 then 0 else 1 end nu
     FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    --INNER JOIN his_manager.noitru_loggiuongbenh giuong  ON T.SOVAOVIEN_NOI = giuong.SOVAOVIEN AND T.SOVAOVIEN_DT_NOI = giuong.SOVAOVIEN_DT
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
    inner join his_manager.noitru_logkhoaphong log on log.stt_benhan = t.stt_benhan and log.sovaovien = t.sovaovien_noi and t.stt_dotdieutri = log.stt_dotdieutri
 inner join his_manager.noitru_xuatvien xv on xv.stt_benhan = t.stt_benhan and
    xv.sovaovien = t.sovaovien_noi and xv.stt_dotdieutri = t.stt_dotdieutri
where t.dvtt = p_dvtt
and trunc(decode(p_cachlay,1,ba.ngay_nhapvien,ba.ngay_ravien)) between p_tungay and p_denngay
;
ELSIF v_ts52090 = 1 THEN-- BDH

      INSERT INTO HIS_REPORTS.BAOCAO_HOATDONGDIEUTRI
        (KHOA,
         SOGIUONG,
         BENHDAUKY,
         BENHTRONGKY,
         TREEM,
         CAPCUU,
         SONGAYDIEUTRI,
         TUVONG,
         TUVONG_TREEM,
         TUVONG_TRUOC24GIO,
         COBAOHIEM,
         BENHCUOIKY,
         NGAYBAOCAO,
         DVTT,
         GHICHU,
         NU)
        -- thống kê nhập viện đầu kỳ
       SELECT  pb.ma_phongban MA_PHONGBAN,
               0 SOGIUONG,
               (CASE WHEN NVL(ptt.TT_PHIEUTHANHTOAN,0) NOT IN (4,5) THEN 1 ELSE 0 END) As BENHDAUKY,
               0 BENHTRONGKY,
               0 TREEM,
               0 CAPCUU,
               0 SONGAYDIEUTRI,
               0 TUVONG,
               0 TUVONG_TREEM,
               0 TUVONG_TRUOC24GIO,
               CASE WHEN ddt.COBHYT = 1 THEN 1 ELSE 0 END COBAOHIEM,
               0 BENHCUOIKY,
               p_denngay NGAYBAOCAO,
               ddt.dvtt DVTT,
               'dauky' GHICHU,
               CASE WHEN bn.gioi_tinh = 1 THEN 0 ELSE 1 END NU
       FROM   HIS_MANAGER.NOITRU_DOTDIEUTRI   ddt
              LEFT JOIN HIS_MANAGER.NOITRU_PHIEUTHANHTOAN ptt
                   ON   ptt.DVTT = p_dvtt
                        AND ddt.SOVAOVIEN = ptt.SOVAOVIEN
                        AND ddt.SOVAOVIEN_DT = ptt.SOVAOVIEN_DT,
              HIS_PUBLIC_LIST.DM_BENH_NHAN    bn,
              HIS_MANAGER.NOITRU_LOGKHOAPHONG khoa,
              HIS_FW.DM_PHONGBAN              pb

       WHERE  ddt.dvtt = p_dvtt
              AND khoa.dvtt = p_dvtt
              AND pb.MA_DONVI = p_dvtt
              AND bn.MA_BENH_NHAN = ddt.MABENHNHAN
             -- AND ddt.STT_BENHAN = khoa.STT_BENHAN
              AND ddt.SOVAOVIEN = khoa.SOVAOVIEN
              AND ddt.SOVAOVIEN_DT = khoa.SOVAOVIEN_DT
             -- AND ddt.STT_DOTDIEUTRI = khoa.STT_DOTDIEUTRI
              AND pb.ma_phongban = khoa.maphongban
              AND khoa.TRANG_THAI != 8
              AND pb.chucnangkhamchuabenh != 4
              AND TRUNC(ddt.NGAY_VAO) <= p_tungay
              AND (ddt.NGAY_RA IS NULL OR TRUNC(ddt.NGAY_RA) > p_tungay)

      -- thống kê nhập viện trong khoảng thời gian
       UNION ALL
       SELECT  pb.ma_phongban MA_PHONGBAN,
               0 SOGIUONG,
               0 BENHDAUKY,
               (CASE WHEN NVL(ptt.TT_PHIEUTHANHTOAN,0) NOT IN (4,5) THEN 1 ELSE 0 END) AS BENHTRONGKY,
               CASE WHEN bn.TUOI < 15 THEN 1
                 ELSE 0
               END TREEM,
               CASE
                 WHEN (EXTRACT(hour from ddt.NGAYVAO) IN (0,6) OR EXTRACT(hour from ddt.NGAYVAO) IN (19,24)
                       OR TO_CHAR(ddt.NGAYVAO, 'HH24:MI') = '07:00') THEN 1
                 ELSE 0
               END CAPCUU,
               (CASE WHEN xv.TINHTRANG_RV IS NULL THEN
                 (CASE WHEN TRUNC(ddt.NGAY_RA) <= p_denngay OR TRUNC(ddt.NGAY_RA) IS NULL THEN
                    TRUNC(ddt.NGAY_RA) - TRUNC(ddt.NGAY_VAO) +1
                   ELSE
                    P_DENNGAY - TRUNC(ddt.NGAY_VAO) + 1
                    END)
                ELSE
                  (CASE WHEN TRUNC(ddt.NGAY_RA) >= p_denngay  THEN
                        HIS_MANAGER.TINHNGAY_DIEUTRI_TT15(ddt.NGAY_VAO, p_denngay, p_dvtt, xv.KETQUADIEUTRI,xv.TINHTRANG_RV,NVL(ct.TUYENBENHVIENCHUYENDI,0),ddt.CAPCUU,ddt.COBHYT )
                   ELSE
                        HIS_MANAGER.TINHNGAY_DIEUTRI_TT15(ddt.NGAY_VAO, ddt.NGAY_RA, p_dvtt, xv.KETQUADIEUTRI,xv.TINHTRANG_RV,NVL(ct.TUYENBENHVIENCHUYENDI,0),ddt.CAPCUU,ddt.COBHYT )
                   END)
                END) As SONGAYDIEUTRI,
               0 TUVONG,
               0 TUVONG_TREEM,
               0 TUVONG_TRUOC24GIO,
               CASE WHEN ddt.COBHYT = 1 THEN 1 ELSE 0 END COBAOHIEM,
               0 BENHCUOIKY,
               p_denngay NGAYBAOCAO,
               ddt.DVTT DVTT,
               'TRONGKY' GHICHU,
               CASE WHEN bn.gioi_tinh = 1 THEN 0 ELSE 1 END NU
       FROM    HIS_MANAGER.noitru_dotdieutri   ddt
               LEFT JOIN HIS_MANAGER.NOITRU_PHIEUTHANHTOAN ptt
                   ON   ptt.DVTT = p_dvtt
                        AND ddt.SOVAOVIEN = ptt.SOVAOVIEN
                        AND ddt.SOVAOVIEN_DT = ptt.SOVAOVIEN_DT
                        AND ddt.STT_DOTDIEUTRI = ptt.STT_DOTDIEUTRI
               LEFT JOIN HIS_MANAGER.NOITRU_XUATVIEN xv
                   ON   xv.DVTT = p_dvtt
                        AND ddt.SOVAOVIEN = xv.SOVAOVIEN
                        AND ddt.SOVAOVIEN_DT = xv.SOVAOVIEN_DT
                        AND ddt.STT_DOTDIEUTRI = xv.STT_DOTDIEUTRI
               LEFT JOIN HIS_MANAGER.NOITRU_CHUYENTUYENBENHNHAN ct
                   ON   ct.DVTT = p_dvtt
                        AND ddt.SOVAOVIEN = ct.SOVAOVIEN
                        AND ddt.SOVAOVIEN_DT = ct.SOVAOVIEN_DT
                        AND ddt.STT_DOTDIEUTRI = ct.STT_DOTDIEUTRI,
               HIS_MANAGER.noitru_logkhoaphong khoa,
               HIS_PUBLIC_LIST.dm_benh_nhan    bn,
               HIS_FW.DM_PHONGBAN              pb
       WHERE   ddt.dvtt = p_dvtt
               AND khoa.dvtt = p_dvtt
               AND pb.MA_DONVI = p_dvtt
               AND khoa.log_nhapvien = 1
               AND khoa.stt_dotdieutri = ddt.stt_dotdieutri
               AND ddt.SOVAOVIEN = khoa.SOVAOVIEN
               AND ddt.SOVAOVIEN_DT = khoa.SOVAOVIEN_DT
               AND ddt.mabenhnhan = bn.ma_benh_nhan
               AND ddt.STT_BENHAN = khoa.STT_BENHAN
               AND pb.ma_phongban = khoa.maphongban
               AND pb.chucnangkhamchuabenh != 4
               AND TRUNC(ddt.NGAY_VAO) BETWEEN p_tungay AND p_denngay
      -- thống kê tử vong trong khoảng thời gian
       UNION ALL
       SELECT pb.ma_phongban MA_PHONGBAN,
              0 GIUONG,
              0 DAUKY,
              0 TRONGKY,
              0 TRONGKY_DUOI15,
              0 CAPPCUU,
              (case when TRUNC(ddt.NGAY_VAO) <= p_tungay then
                  TRUNC(tv.NGAY_TUVONG) - p_tungay +1
                 else
                  TRUNC(tv.NGAY_TUVONG) - ddt.NGAY_VAO +1
                  end) As SONGAYDIEUTRI,
              (CASE WHEN NVL(ptt.TT_PHIEUTHANHTOAN,0) NOT IN (4,5) THEN 1 ELSE 0 END) AS TUVONG,
              CASE WHEN bn.TUOI < 15 THEN 1 ELSE 0 END TUVONG_DUOI15,
              CASE WHEN (to_date(to_char(tv.NGAY_TUVONG, 'yyyy-mm-dd'),'yyyy-mm-dd') - to_date(to_char(ddt.NGAY_VAO, 'yyyy-mm-dd'),'yyyy-mm-dd')) <= 1 THEN 1 ELSE 0 END TUVONG_TRUOC24GIO,
              0 COBAOHIEM,
              0 BENHCUOIKY,
              p_denngay NGAYBAOCAO,
              ddt.dvtt DVTT,
              'tuvong' GHICHU,
              CASE WHEN bn.gioi_tinh = 1 THEN 0 ELSE 1 END nu

       FROM   HIS_MANAGER.NOITRU_TUVONG             tv,
              HIS_MANAGER.NOITRU_DOTDIEUTRI         ddt,
              HIS_PUBLIC_LIST.DM_BENH_NHAN          bn,
              HIS_MANAGER.NOITRU_PHIEUTHANHTOAN     ptt,
              HIS_FW.DM_PHONGBAN                    pb

       WHERE  tv.dvtt = p_dvtt
              AND ptt.DVTT = p_dvtt
              AND ddt.DVTT = p_dvtt
              AND pb.MA_DONVI = p_dvtt
              AND TRUNC(tv.NGAY_TUVONG) between p_tungay AND p_denngay
              AND ddt.MABENHNHAN  = tv.MABENHNHAN
             -- AND ddt.STT_BENHAN = tv.STT_BENHAN
              AND ddt.SOVAOVIEN = tv.SOVAOVIEN
              AND ddt.SOVAOVIEN_DT = tv.SOVAOVIEN_DT
             -- AND tv.STT_DOTDIEUTRI = ptt.STT_DOTDIEUTRI
              AND tv.stt_dotdieutri = ddt.stt_dotdieutri
             -- AND ddt.STT_BENHAN = ptt.STT_BENHAN
              AND bn.MA_BENH_NHAN = tv.MABENHNHAN
              AND pb.MA_PHONGBAN = tv.KHOA_TUVONG
              AND ddt.SOVAOVIEN = ptt.SOVAOVIEN
              AND ddt.SOVAOVIEN_DT = ptt.SOVAOVIEN_DT
              AND pb.chucnangkhamchuabenh != 4
      -- thống kê bệnh nhân còn năm viện
       UNION ALL
       SELECT pb.ma_phongban MA_PHONGBAN,
              0 GIUONG,
              0 DAUKY,
              0 TRONGKY,
              0 TRONGKY_DUOI15,
              0 CAPPCUU,
              0 SONGAYDIEUTRI,
              0 TUVONG,
              0 TUVONG_DUOI15,
              0 TUVONG_TRUOC24GIO,
              0 COBAOHIEM,
              (CASE WHEN NVL(ptt.TT_PHIEUTHANHTOAN,0) NOT IN (4,5) THEN 1 ELSE 0 END) AS CUOIKY,
              p_denngay NGAYBAOCAO,
              ddt.dvtt DVTT,
              'cuoiky' GHICHU,
              CASE WHEN bn.gioi_tinh = 1 THEN 0 ELSE 1 END nu

       FROM   his_manager.noitru_dotdieutri ddt
              LEFT JOIN HIS_MANAGER.NOITRU_PHIEUTHANHTOAN ptt
                   ON   ptt.DVTT = p_dvtt
                        AND ddt.SOVAOVIEN = ptt.SOVAOVIEN
                        AND ddt.SOVAOVIEN_DT = ptt.SOVAOVIEN_DT
                        AND ddt.STT_DOTDIEUTRI = ptt.STT_DOTDIEUTRI
               LEFT JOIN HIS_MANAGER.NOITRU_XUATVIEN xv
                   ON   xv.DVTT = p_dvtt
                        AND ddt.SOVAOVIEN = xv.SOVAOVIEN
                        AND ddt.SOVAOVIEN_DT = xv.SOVAOVIEN_DT
                        AND ddt.STT_DOTDIEUTRI = xv.STT_DOTDIEUTRI
               LEFT JOIN HIS_MANAGER.NOITRU_CHUYENTUYENBENHNHAN ct
                   ON   ct.DVTT = p_dvtt
                        AND ddt.SOVAOVIEN = ct.SOVAOVIEN
                        AND ddt.SOVAOVIEN_DT = ct.SOVAOVIEN_DT
                        AND ddt.STT_DOTDIEUTRI = ct.STT_DOTDIEUTRI,
              his_manager.noitru_logkhoaphong khoa,
              his_fw.dm_phongban pb,
              his_public_list.dm_benh_nhan bn

       WHERE  ddt.dvtt = p_dvtt
              AND khoa.dvtt = p_dvtt
              AND pb.MA_DONVI = p_dvtt
              AND ddt.mabenhnhan = bn.MA_BENH_NHAN
              AND pb.ma_phongban = khoa.maphongban
              AND ddt.SOVAOVIEN = khoa.SOVAOVIEN
              AND ddt.SOVAOVIEN_DT = khoa.SOVAOVIEN_DT
              AND pb.chucnangkhamchuabenh != 4
              AND ((khoa.TRANG_THAI = 8 AND TRUNC(khoa.NGAY_CHUYENDI) > p_denngay)
                  OR (khoa.TRANG_THAI != 8 AND TRUNC(khoa.NGAY_CHUYENDEN) <= p_denngay ))
              AND (ddt.NGAY_RA IS NULL OR TRUNC(ddt.NGAY_RA) > p_denngay)
              AND TRUNC(ddt.NGAY_VAO) <= p_denngay;
else
--so luong nguoi benh dau ky
INSERT INTO HIS_REPORTS.BAOCAO_HOATDONGDIEUTRI
  (KHOA,
   SOGIUONG,
   BENHDAUKY,
   BENHTRONGKY,
   TREEM,
   CAPCUU,
   SONGAYDIEUTRI,
   TUVONG,
   TUVONG_TREEM,
   TUVONG_TRUOC24GIO,
   COBAOHIEM,
   BENHCUOIKY,
   NGAYBAOCAO,
   DVTT,
   GHICHU,
   NU)

  SELECT BA.NHAPVIENVAOKHOA,
         0 SOGIUONG,
         1 BENHDAUKY,
         0 BENHTRONGKY,
         0 TREEM,
         0 CAPCUU,
         0 SONGAYDIEUTRI,
         0 TUVONG,
         0 TUVONG_TREEM,
         0 TUVONG_TRUOC24GIO,
         CASE
           WHEN T.MUC_HUONG > 0 THEN
            1
           ELSE
            0
         END COBAOHIEM,
         0 BENHCUOIKY,
         P_DENNGAY NGAYBAOCAO,
         BA.DVTT DVTT,
         'DAUKY' GHICHU,
         CASE
           WHEN T.GIOI_TINH = 1 THEN
            0
           ELSE
            1
         END NU
    FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
   WHERE T.DVTT = P_DVTT
     AND NVL(TRUNC(BA.NGAY_RAVIEN),SYSDATE) > P_NGAYDAUKY
     AND TRUNC(BA.NGAY_NHAPVIEN) <= P_NGAYDAUKY
UNION ALL

-- th?ng kê nh?p vi?n trong kho?ng th?i gan

  SELECT BA.NHAPVIENVAOKHOA,
         0 SOGIUONG,
         0 BENHDAUKY,
         1 BENHTRONGKY,
         CASE
           WHEN BN.TUOI < 15 THEN
            1
           ELSE
            0
         END TREEM,
         CASE
           WHEN T.CAPCUU = 1 THEN
            1
           ELSE
            0
         END CAPCUU,
         0 SONGAYDIEUTRI,
         0 TUVONG,
         0 TUVONG_TREEM,
         0 TUVONG_TRUOC24GIO,
         CASE
           WHEN T.MUC_HUONG > 0 THEN
            1
           ELSE
            0
         END COBAOHIEM,
         0 BENHCUOIKY,
         P_DENNGAY NGAYBAOCAO,
         BA.DVTT DVTT,
         'TRONGKY' GHICHU,
         CASE
           WHEN T.GIOI_TINH = 1 THEN
            0
           ELSE
            1
         END NU
    FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
    INNER JOIN HIS_MANAGER.NOITRU_PHIEUTHANHTOAN PTT ON PTT.SOVAOVIEN = T.SOVAOVIEN_NOI AND PTT.SOVAOVIEN_DT=T.SOVAOVIEN_DT_NOI
    INNER JOIN HIS_PUBLIC_LIST.DM_BENH_NHAN    BN ON BA.MABENHNHAN = BN.MA_BENH_NHAN
   WHERE T.DVTT = P_DVTT
   AND NVL(PTT.TT_PHIEUTHANHTOAN,0) <= 4
     AND TRUNC(decode(p_cachlay,1,ba.ngay_nhapvien,ba.ngay_ravien)) BETWEEN P_TUNGAY AND P_DENNGAY

UNION ALL

  SELECT BA.NHAPVIENVAOKHOA,
         0 AS GIUONG,
         0 AS DAUKY,
         0 AS TRONGKY,
         0 AS TRONGKY_DUOI15,
         0 AS CAPCUU,
         0 AS SONGAY,
         1 AS TUVONG,
         CASE
           WHEN BN.TUOI < 15 THEN
            1
           ELSE
            0
         END AS TUVONG_DUOI15,
         CASE
           WHEN NGAY_RAVIEN - NGAY_NHAPVIEN <= 1 THEN
            1
           ELSE
            0
         END AS TUVONG_TRONG24H,
         0 AS COBH,
         0,
         P_DENNGAY,
         BA.DVTT,
         'TUVONG',
         CASE
           WHEN BN.GIOI_TINH = 1 THEN
            0
           ELSE
            1
         END NU
    FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
    INNER JOIN HIS_PUBLIC_LIST.DM_BENH_NHAN    BN ON BA.MABENHNHAN = BN.MA_BENH_NHAN
   WHERE T.DVTT = P_DVTT
     and ba.TRANG_THAI = 5
     AND TRUNC(decode(p_cachlay,1,ba.ngay_nhapvien,ba.ngay_ravien)) BETWEEN P_TUNGAY AND P_DENNGAY

UNION ALL
-- th?ng kê b?nh nhân còn nam vi?n

SELECT BA.NHAPVIENVAOKHOA,0 as giuong,0 as dauky,0 as trongky,0 as trongky_duoi15,0 as capcuu, 0 as songay,0 as tuvong,0 as tuvong_duoi15,0 as tuvong_trong24h,0 as cobh,1 as cuoiky,p_denngay,ba.dvtt,'cuoiky',case when bn.gioi_tinh = 1 then 0 else 1 end nu
     FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
    INNER JOIN HIS_PUBLIC_LIST.DM_BENH_NHAN    BN ON BA.MABENHNHAN = BN.MA_BENH_NHAN
where t.dvtt = p_dvtt
and nvl(ba.ngay_ravien,sysdate) > p_denngay
and trunc(ba.ngay_nhapvien) <= p_denngay

UNION ALL


SELECT BA.NHAPVIENVAOKHOA,0 as giuong,0 as dauky,0 as trongky,0 as trongky_duoi15,0 as capcuu,nvl(songaydieutri,0) as songay,0 as tuvong,0 as tuvong_duoi15,0 as tuvong_trong24h,0 as cobh,0,p_denngay,ba.dvtt,'songaydieutri',case when T.gioi_tinh = 1 then 0 else 1 end nu
     FROM HIS_SYNCHRONIZATION.B1_CHITIEUTONGHOP_KCB T
    INNER JOIN his_manager.noitru_loggiuongbenh giuong  ON T.SOVAOVIEN_NOI = giuong.SOVAOVIEN AND T.SOVAOVIEN_DT_NOI = giuong.SOVAOVIEN_DT
    INNER JOIN HIS_MANAGER.NOITRU_BENHAN       BA ON BA.SOVAOVIEN = T.SOVAOVIEN_NOI
where t.dvtt = p_dvtt
and trunc(decode(p_cachlay,1,ba.ngay_nhapvien,ba.ngay_ravien)) between p_tungay and p_denngay
;
end if;
--commit;

END;

