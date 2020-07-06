  CREATE OR REPLACE EDITIONABLE PROCEDURE "HIS_MANAGER"."KB_NGT_TT_SL_BIN_TT52" (P_MA_TOA_THUOC IN VARCHAR2,
                                                              P_DVTT         IN VARCHAR2,
                                                              P_NGHIEP_VU    IN VARCHAR2,
                                                              P_MABACSI      IN VARCHAR2,
                                                              P_SOVAOVIEN    IN NUMBER,
                                                              CUR            OUT SYS_REFCURSOR) IS
  P_COUNTBS      NUMBER(10) DEFAULT 0;
  V_THAMSO       NUMBER(10) DEFAULT 0;
  V_SOVAOVIEN    NUMBER(11);
  V_PHANTRAMBH   NUMBER(10) DEFAULT 0;
  V_PHIEU        VARCHAR2(100) DEFAULT ' ';
  V_BNTRA        NUMBER(18) DEFAULT 0;
  V_BHXH_BNTRA   NUMBER(18) DEFAULT 0;
  V_MABN         NUMBER(18) DEFAULT 0;
  V_XETCMND      NUMBER(5) DEFAULT 0;
  V_NGUOILIENHE  VARCHAR2(500) DEFAULT ' ';
  V_CMND         VARCHAR2(100) DEFAULT ' ';
  V_SOTHEBHYT    VARCHAR2(100) DEFAULT ' ';
  V_POS1         NUMBER(3) DEFAULT - 1;
  V_POS2         NUMBER(3) DEFAULT - 1;
  P_HIENTHI      NUMBER(1);
  V_THAMSOTT52   NUMBER(11);
  V_THAMSO820124 NUMBER(11); --TOA THUỐC NGOẠI TRÚ TT52 TOA BHYT KHÔNG HIỂN THỊ VẬT TƯ BHYT
  V_THAMSO820125 NUMBER(11); -- HIỂN THỊ CMND_NGUOILH Ở FORM TIẾP NHẬN
  V_CMND_NGLH    VARCHAR2(50) DEFAULT ' ';
  v_hienthisdt varchar2(10) := HIS_FW.DM_TSDV_SL_MTSO(p_dvtt, '82233');
  V_thamso_82833 number(2) default 0; -- THAM SỐ LẤY SỐ ĐIỆN THOẠI TỪ DANH MỤC NHÂN VIÊN
  v_tenht_toadv_82431 varchar2(2) := HIS_FW.DM_TSDV_SL_MTSO(p_dvtt, '82431');
BEGIN
    BEGIN
          SELECT MOTA_THAMSO
            INTO V_thamso_82833
            FROM HIS_FW.DM_THAMSO_DONVI
           WHERE DVTT = P_DVTT
             AND MA_THAMSO = 82833;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            V_thamso_82833 := 0;
        END;
  if v_tenht_toadv_82431 = 1 and P_NGHIEP_VU = 'ngoaitru_toadichvu' then
    v_tenht_toadv_82431 := 1;
  else
    v_tenht_toadv_82431 := 0;
  end if;
  DELETE FROM TMP_KB_CTTT;
  BEGIN
    SELECT SOPHIEUTHANHTOAN, T_BNTRA, T_BHXH_BN_TT
      INTO V_PHIEU, V_BNTRA, V_BHXH_BNTRA
      FROM KB_PHIEUTHANHTOAN
     WHERE DVTT = P_DVTT
       AND SOVAOVIEN = P_SOVAOVIEN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_PHIEU      := ' ';
      V_BNTRA      := 0;
      V_BHXH_BNTRA := 0;
  END;
  BEGIN
    SELECT nvl(SO_THE_BHYT,'    ')
      INTO V_SOTHEBHYT
      FROM HIS_MANAGER.KB_TIEP_NHAN
     WHERE DVTT = P_DVTT
       AND SOVAOVIEN = P_SOVAOVIEN;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_SOTHEBHYT := ' ';
  END;
  BEGIN
    SELECT T.SOVAOVIEN, T.MABENHNHAN
      INTO V_SOVAOVIEN, V_MABN
      FROM HIS_MANAGER.KB_TOA_THUOC T
     WHERE DVTT = P_DVTT
       AND T.MA_TOA_THUOC = P_MA_TOA_THUOC;
    SELECT MOTA_THAMSO
      INTO V_THAMSO
      FROM HIS_FW.DM_THAMSO_DONVI
     WHERE DVTT = P_DVTT
       AND MA_THAMSO = 66;
    BEGIN
      SELECT MOTA_THAMSO
        INTO V_THAMSOTT52
        FROM HIS_FW.DM_THAMSO_DONVI
       WHERE DVTT = P_DVTT
         AND MA_THAMSO = 820357;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_THAMSOTT52 := 0;
    END;
    BEGIN
      SELECT MOTA_THAMSO
        INTO V_THAMSO820125
        FROM HIS_FW.DM_THAMSO_DONVI
       WHERE DVTT = P_DVTT
         AND MA_THAMSO = 820125;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_THAMSO820125 := 0;
    END;
    BEGIN
      SELECT MOTA_THAMSO
        INTO V_THAMSO820124
        FROM HIS_FW.DM_THAMSO_DONVI
       WHERE DVTT = P_DVTT
         AND MA_THAMSO = 820124;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        V_THAMSO820124 := 0;
    END;
    -- AGG DUY 23/12/2016 LẤY GIÁ TRỊ PHẦN TRẰM ĐỒNG CHI TRA
    SELECT CAST((100 - TI_LE_MIEN_GIAM) AS DECIMAL(18, 0))
      INTO V_PHANTRAMBH
      FROM HIS_MANAGER.KB_TIEP_NHAN
     WHERE DVTT = P_DVTT
       AND SOVAOVIEN = V_SOVAOVIEN;
    -- AGG QUÍ 29/06/2016 B? SUNG THÊM THÔNG TIN TRÊN TOA TT05: MABN, SOPHIEU,KCB BAN DAU, LOI DAN, NGAY HEN
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_SOVAOVIEN  := 0;
      V_THAMSO     := 0;
      V_PHANTRAMBH := 0;
      V_MABN       := 0;
  END;
  BEGIN
    SELECT TO_NUMBER(INSTR(BN.NGUOI_LIEN_HE, '(')),
           BN.NGUOI_LIEN_HE,
           BN.CMND_NGUOILH
      INTO V_XETCMND, V_NGUOILIENHE, V_CMND_NGLH
      FROM HIS_PUBLIC_LIST.DM_BENH_NHAN BN
     WHERE BN.MA_BENH_NHAN = V_MABN
       AND ROWNUM = 1;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_XETCMND     := 0;
      V_NGUOILIENHE := ' ';
      V_CMND_NGLH   := ' ';
  END;
  IF V_XETCMND > 0 THEN
    V_POS1        := TO_NUMBER(INSTR(V_NGUOILIENHE, '('));
    V_POS2        := TO_NUMBER(INSTR(V_NGUOILIENHE, ')'));
    V_CMND        := SUBSTR(V_NGUOILIENHE, V_POS1 + 1, V_POS2 - V_POS1 - 1);
    V_NGUOILIENHE := REPLACE(V_NGUOILIENHE, '(' || V_CMND || ')', ' ');
    V_CMND := CASE
                WHEN V_THAMSO820125 = 1 THEN
                 V_CMND_NGLH
                ELSE
                 TRIM(V_CMND)
              END;
    V_NGUOILIENHE := TRIM(V_NGUOILIENHE);
  ELSE
    V_CMND := CASE
                WHEN V_THAMSO820125 = 1 THEN
                 V_CMND_NGLH
                ELSE
                 ' '
              END;
  END IF;
  INSERT INTO TMP_KB_CTTT
    (DVTT,
     STT_ORDER,
     MAVATTU,
     TEN_VAT_TU,
     SANG_UONG,
     TRUA_UONG,
     CHIEU_UONG,
     TOI_UONG,
     GHI_CHU_CT_TOA_THUOC,
     MA_TOA_THUOC,
     MA_BAC_SI_THEMTHUOC,
     SO_LUONG,
     MABENHNHAN,
     SO_LUONG_THUC_LINH,
     THANHTIEN_THUOC,
     CACH_SU_DUNG,
     NGHIEP_VU,
     SOVAOVIEN,
     MA_KHAM_BENH,
     SOPHIEUTHANHTOAN)
    SELECT DVTT,
           MIN(CT.STT_ORDER) OVER(PARTITION BY TEN_VAT_TU, SANG_UONG, TRUA_UONG, CHIEU_UONG, TOI_UONG, GHI_CHU_CT_TOA_THUOC, MA_TOA_THUOC, MA_BAC_SI_THEMTHUOC) STT_ORDER,
           MAVATTU,
           TEN_VAT_TU,
           SANG_UONG,
           TRUA_UONG,
           CHIEU_UONG,
           TOI_UONG,
           GHI_CHU_CT_TOA_THUOC,
           MA_TOA_THUOC,
           MA_BAC_SI_THEMTHUOC,
           SO_LUONG AS SO_LUONG,
           MABENHNHAN,
           SO_LUONG_THUC_LINH,
           THANHTIEN_THUOC,
           CACH_SU_DUNG,
           NGHIEP_VU,
           SOVAOVIEN,
           MA_KHAM_BENH,
           SOPHIEUTHANHTOAN
      FROM KB_CHI_TIET_TOA_THUOC CT
     WHERE MA_TOA_THUOC = P_MA_TOA_THUOC
       AND DVTT = P_DVTT
       AND SOVAOVIEN = P_SOVAOVIEN;
  IF SUBSTR(P_DVTT, 1, 2) = 89 THEN
    IF (P_NGHIEP_VU = 'ngoaitru_toathuoc') THEN
      SELECT COUNT(DISTINCT MA_BAC_SI_THEMTHUOC)
        INTO P_COUNTBS
        FROM TMP_KB_CTTT
       WHERE DVTT = P_DVTT
         AND MA_TOA_THUOC = P_MA_TOA_THUOC
         AND UPPER(NGHIEP_VU) IN ('NGOAITRU_TOATHUOC', 'NGOAITRU_TOAVATTU');
      OPEN CUR FOR
        SELECT NVL(V_PHANTRAMBH, '') AS TILE, -- AGG DUY 23/12/2016 LẤY GIÁ TRỊ PHẦN TRĂM ĐỒNG CHI TRẢ
               -- AN GIANG B? SUNG
               BN.MA_BENH_NHAN, -- CT.SOPHIEUTHANHTOAN
               V_PHIEU AS SOPHIEUTHANHTOAN,
               DMDV.TEN_DONVI AS NOIDKBD,
               TOA.TEN_PHONG_INTOA AS PHONGKHAM,
               TO_CHAR(KB.NGAY_HEN, 'DD/MM/YYYY') AS NGAYTAIKHAM,
               --NVL(THL.MATTRAI_KC,' ') AS TRAIKC, NVL(THL.MATTRAI_CC,' ') AS TRAICK,NVL(THL.MATPHAI_KC,' ') AS PHAIKC,NVL(THL.MATPHAI_CC,' ') AS PHAICK,
               CASE UPPER(CT.NGHIEP_VU)
                 WHEN 'NGOAITRU_TOATHUOC' THEN
                  TOA.LOI_DAN_TOA_THUOC
                 WHEN 'NGOAITRU_TOAVATTU' THEN
                  TOA.LOI_DAN_TOA_VATTU_BHYT
                 WHEN 'NGOAITRU_TOAMUANGOAI' THEN
                  TOA.LOI_DAN_TOA_THUOC_MUANGOAI
                 WHEN 'NGOAITRU_TOAMIENPHI' THEN
                  TOA.LOI_DAN_TOA_THUOC_MIENPHI
                 WHEN 'NGOAITRU_TOAQUAYBANTHUOCBV' THEN
                  TOA.LOI_DAN_TOA_THUOC_MUATAIQUAYBV
                 WHEN 'NGOAITRU_TOADICHVU' THEN
                  TOA.LOI_DAN_TOA_DICHVU_NGOAITRU
                 WHEN 'NGOAITRU_TOADONGY' THEN
                  TOA.LOI_DAN_TOA_DONGY
               END AS LOIDANTHUOC,
               -- AN GIANG B? SUNG
               HTQL.TEN_HETHONG,
               TN.STT_HANGNGAY AS STT_HANGNGAY,
               MIN(CT.STT_ORDER) AS STT_ORDER,
               NV.TEN_NHANVIEN AS TEN_NHANVIEN, -- CONCAT('BÁC SI CH? D?NH THU?C: ',NV.TEN_NHANVIEN)   AS TEN_NHANVIEN,
               VT.DVT,
               UPPER(VT.TENVATTU) AS TENVATTU,
               UPPER(VT.HOATCHAT) AS HOATCHAT,
               CASE
                 WHEN VT.MALOAIHINH = 5005 THEN
                  UPPER(VT.TENVATTU)
                 WHEN VT.MALOAIHINH = 5006 THEN
                 case when p_dvtt = '86080' then UPPER(VT.TEN_HIEN_THI) else VT.TEN_HIEN_THI end -- VLG
                 WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                  CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                         VT.TENVATTU,
                         ')')
                 ELSE
                  CONCAT(CONCAT(UPPER(SUBSTR(VT.HOATCHAT, 1, 1)),
                                LOWER(SUBSTR(VT.HOATCHAT, 2))) || ' ' || ' (' ||
                         VT.TENVATTU,
                         ') ' || VT.HAMLUONG)
               END AS MOTA_CHITIET1,
               CASE
                 WHEN SUM(CT.SO_LUONG) < 10 THEN
                  'SL: ' ||
                  CONCAT('0',
                         CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                              VARCHAR2(500))) || CONCAT(' ', VT.DVT) || ' ' || ''
                 ELSE
                  'SL: ' || CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                                 VARCHAR2(500)) || CONCAT(' ', VT.DVT) || ' ' || ''
               END AS SO_LUONG_UONG,
               CASE
                 WHEN SANG_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('SÁNG ', CHUYEN_THAPPHAN_SANG_PHANSO(SANG_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS SANG_UONG,
               CASE
                 WHEN TRUA_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('TRƯA ', CHUYEN_THAPPHAN_SANG_PHANSO(TRUA_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS TRUA_UONG,
               CASE
                 WHEN CHIEU_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('CHIỀU ', CHUYEN_THAPPHAN_SANG_PHANSO(CHIEU_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS CHIEU_UONG,
               CASE
                 WHEN TOI_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('TỐI ', CHUYEN_THAPPHAN_SANG_PHANSO(TOI_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS TOI_UONG,
               CASE GHI_CHU_CT_TOA_THUOC
                 WHEN NULL THEN
                  ''
                 WHEN '' THEN
                  ''
                 ELSE
                  CONCAT('GHI CHÚ: ', GHI_CHU_CT_TOA_THUOC)
               END AS GHI_CHU_CT_TOA_THUOC,
               CT.MA_TOA_THUOC,
               SUM(SO_LUONG) AS SO_LUONG,
               MA_BAC_SI_THEMTHUOC,
               SUM(SO_LUONG_THUC_LINH) AS SO_LUONG_THUC_LINH,
               SUM(THANHTIEN_THUOC) AS THANHTIEN_THUOC,
               CASE CACH_SU_DUNG
                 WHEN NULL THEN
                  ''
                 WHEN '' THEN
                  ''
                 ELSE
                  '( ' || CACH_SU_DUNG || ' )'
               END AS CACH_SU_DUNG,
               CASE GHI_CHU_CT_TOA_THUOC
                 WHEN NULL THEN
                  ''
                 WHEN '' THEN
                  ''
                 ELSE
                  CONCAT(GHI_CHU_CT_TOA_THUOC, ' :')
               END AS GHI_CHU_CT_TOA_THUOC1,
               P_COUNTBS AS TT,
               HIS_MANAGER.HIENTHI_TUOI_BENHNHAN(BN.NGAY_SINH) AS TUOI,
               NVL(V_NGUOILIENHE, ' ') AS NGUOILIENHE,
               CASE V_thamso_82833 WHEN 1 THEN NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                WHEN 2 THEN  NVL(NV.SODIENTHOAI_NHANVIEN, NVL(DMDV.SODIENTHOAI, ' '))
                WHEN 3 THEN NVL(DMDV.SODIENTHOAI, NVL(NV.SODIENTHOAI_NHANVIEN, ' '))
                ELSE NVL(DMDV.SODIENTHOAI, ' ') END AS SODIENTHOAI,
               NVL(V_CMND, ' ') AS SOCMT,
               V_SOTHEBHYT SOTHEBHYT
               ,gskgg.STT_GOISO as stt_goiso
          FROM TMP_KB_CTTT CT
        -- AN GIANG B? SUNG
          LEFT JOIN KB_TOA_THUOC TOA
            ON TOA.MA_TOA_THUOC = CT.MA_TOA_THUOC
           AND TOA.DVTT = P_DVTT
           AND TOA.SOVAOVIEN = CT.SOVAOVIEN
          LEFT JOIN KB_TIEP_NHAN TN
            ON TN.SOVAOVIEN = CT.SOVAOVIEN
           AND TN.DVTT = P_DVTT
          LEFT JOIN KB_KHAM_BENH KB
            ON CT.MA_KHAM_BENH = KB.MA_KHAM_BENH
           AND CT.SOVAOVIEN = KB.SOVAOVIEN
           AND KB.DVTT = P_DVTT
        --LEFT JOIN AGG_KB_NGOAITRU_THILUC THL ON CT.ID_TIEPNHAN = THL.ID_TIEPNHAN AND CT.MABENHNHAN = THL.MA_BENH_NHAN AND THL.DVTT = P_DVTT
          LEFT JOIN HIS_FW.DM_DONVI DMDV
            ON DMDV.MA_DONVI = TN.DVTT
          left join HIS_MANAGER.GOI_SO_KGG gskgg ON gskgg.SOVAOVIEN = KB.SOVAOVIEN and gskgg.dvtt=p_dvtt and gskgg.NGHIEP_VU = 'duoc'
        -- AN GIANG B? SUNG
         , DC_TB_VATTU VT, HIS_FW.DM_NHANVIEN NV,
         HIS_PUBLIC_LIST.DM_BENH_NHAN BN, HIS_FW.DM_HETHONGQUANLY HTQL
         WHERE CT.MA_TOA_THUOC = P_MA_TOA_THUOC
           AND HTQL.MA_HETHONG = P_DVTT
           AND HTQL.MA_HETHONG = CT.DVTT
           AND UPPER(CT.NGHIEP_VU) IN ('NGOAITRU_TOATHUOC', 'NGOAITRU_TOAVATTU')
           AND CT.DVTT = P_DVTT
           AND CT.MAVATTU = VT.MAVATTU
           AND VT.DVTT = P_DVTT
           AND NV.MA_NHANVIEN = CT.MA_BAC_SI_THEMTHUOC
           AND CT.MA_BAC_SI_THEMTHUOC = (CASE
                 WHEN P_MABACSI != '0' THEN
                  P_MABACSI
                 ELSE
                  CAST(CT.MA_BAC_SI_THEMTHUOC AS VARCHAR2(11))
               END)
           AND CT.MABENHNHAN = BN.MA_BENH_NHAN
           AND TOA.SOVAOVIEN = V_SOVAOVIEN
           AND TN.SOVAOVIEN = V_SOVAOVIEN
           AND KB.SOVAOVIEN = V_SOVAOVIEN
         GROUP BY NV.TEN_NHANVIEN,
                  VT.DVT,
                  TENVATTU,
                  SANG_UONG,
                  TRUA_UONG,
                  CHIEU_UONG,
                  TOI_UONG,
                  GHI_CHU_CT_TOA_THUOC,
                  CT.MA_TOA_THUOC,
                  MA_BAC_SI_THEMTHUOC,
                  CACH_SU_DUNG,
                  CT.STT_ORDER,
                  HTQL.TEN_HETHONG,
                  TN.STT_HANGNGAY,
                  VT.MALOAIHINH,
                  BN.TUOI,
                  BN.NGUOI_LIEN_HE,
                  VT.HOATCHAT,
                  VT.HAMLUONG,
                  CT.NGHIEP_VU,
                  BN.MA_BENH_NHAN,
                  CT.SOPHIEUTHANHTOAN,
                  DMDV.TEN_DONVI,
                  TOA.TEN_PHONG_INTOA,
                  KB.NGAY_HEN,
                  TOA.LOI_DAN_TOA_THUOC,
                  TOA.LOI_DAN_TOA_VATTU_BHYT,
                  TOA.LOI_DAN_TOA_THUOC_MUANGOAI,
                  TOA.LOI_DAN_TOA_THUOC_MIENPHI,
                  TOA.LOI_DAN_TOA_THUOC_MUATAIQUAYBV,
                  TOA.LOI_DAN_TOA_DICHVU_NGOAITRU,
                  TOA.LOI_DAN_TOA_DONGY,
                  VT.TENVATTUHIENTHI,
                  BN.NGAY_SINH,
                  DMDV.SODIENTHOAI,
                  V_CMND,
                  V_SOTHEBHYT,
                  V_NGUOILIENHE,
                  NV.SODIENTHOAI_NHANVIEN
                  ,gskgg.STT_GOISO
        HAVING SUM(SO_LUONG) > 0
         ORDER BY STT_ORDER ASC;
    ELSE
      SELECT COUNT(DISTINCT MA_BAC_SI_THEMTHUOC)
        INTO P_COUNTBS
        FROM TMP_KB_CTTT
       WHERE DVTT = P_DVTT
         AND MA_TOA_THUOC = P_MA_TOA_THUOC
         AND NGHIEP_VU = P_NGHIEP_VU;
      OPEN CUR FOR
        SELECT NVL(V_PHANTRAMBH, '') AS TILE,
               -- AGG DUY 23/12/2016 LẤY GIÁ TRỊ PHẦN TRĂM ĐỒNG CHI TRẢ
               -- AN GIANG B? SUNG
               BN.MA_BENH_NHAN, --CT.SOPHIEUTHANHTOAN
               V_PHIEU AS SOPHIEUTHANHTOAN,
               DMDV.TEN_DONVI AS NOIDKBD,
               TOA.TEN_PHONG_INTOA AS PHONGKHAM,
               TO_CHAR(KB.NGAY_HEN, 'DD/MM/YYYY') AS NGAYTAIKHAM,
               -- NVL(THL.MATTRAI_KC,' ') AS TRAIKC, NVL(THL.MATTRAI_CC,' ') AS TRAICK,NVL(THL.MATPHAI_KC,' ') AS PHAIKC,NVL(THL.MATPHAI_CC,' ') AS PHAICK,
               CASE UPPER(CT.NGHIEP_VU)
                 WHEN 'NGOAITRU_TOATHUOC' THEN
                  TOA.LOI_DAN_TOA_THUOC
                 WHEN 'NGOAITRU_TOAVATTU' THEN
                  TOA.LOI_DAN_TOA_VATTU_BHYT
                 WHEN 'NGOAITRU_TOAMUANGOAI' THEN
                  TOA.LOI_DAN_TOA_THUOC_MUANGOAI
                 WHEN 'NGOAITRU_TOAMIENPHI' THEN
                  TOA.LOI_DAN_TOA_THUOC_MIENPHI
                 WHEN 'NGOAITRU_TOAQUAYBANTHUOCBV' THEN
                  TOA.LOI_DAN_TOA_THUOC_MUATAIQUAYBV
                 WHEN 'NGOAITRU_TOADICHVU' THEN
                  TOA.LOI_DAN_TOA_DICHVU_NGOAITRU
                 WHEN 'NGOAITRU_TOADONGY' THEN
                  TOA.LOI_DAN_TOA_DONGY
               END AS LOIDANTHUOC,
               -- AN GIANG B? SUNG
               HTQL.TEN_HETHONG,
               MIN(CT.STT_ORDER) AS STT_ORDER,
               NV.TEN_NHANVIEN AS TEN_NHANVIEN, -- CONCAT('BÁC SI CH? D?NH THU?C: ',NV.TEN_NHANVIEN)   AS TEN_NHANVIEN
               VT.DVT,
               UPPER(VT.TENVATTU) AS TENVATTU,
               UPPER(VT.HOATCHAT) AS HOATCHAT,
               -- CASE WHEN VT.HOATCHAT !='' THEN CONCAT(CONCAT(UPPER(VT.HOATCHAT),' (',VT.TENVATTU), ')') ELSE UPPER(VT.TENVATTU) END AS MOTA_CHITIET,
               CASE
                 WHEN VT.MALOAIHINH = 5005 THEN
                  UPPER(VT.TENVATTU)
                 WHEN VT.MALOAIHINH = 5006 THEN
                  case when p_dvtt = '86080' then UPPER(VT.TEN_HIEN_THI) else VT.TEN_HIEN_THI end -- VLG
                 WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                  CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                         VT.TENVATTU,
                         ')')
                 ELSE
                  CONCAT(CONCAT(UPPER(SUBSTR(VT.HOATCHAT, 1, 1)),
                                LOWER(SUBSTR(VT.HOATCHAT, 2))) || ' ' || ' (' ||
                         VT.TENVATTU,
                         ') ' || VT.HAMLUONG)
               END AS MOTA_CHITIET1,
               CASE
                 WHEN SUM(CT.SO_LUONG) < 10 THEN
                  'SL: ' ||
                  CONCAT('0',
                         CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                              VARCHAR2(500))) || CONCAT(' ', VT.DVT) || ' ' || ''
                 ELSE
                  'SL: ' || CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                                 VARCHAR2(500)) || CONCAT(' ', VT.DVT) || ' ' || ''
               END AS SO_LUONG_UONG,
               CASE
                 WHEN SANG_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('SÁNG ', CHUYEN_THAPPHAN_SANG_PHANSO(SANG_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS SANG_UONG,
               CASE
                 WHEN TRUA_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('TRƯA ', CHUYEN_THAPPHAN_SANG_PHANSO(TRUA_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS TRUA_UONG,
               CASE
                 WHEN CHIEU_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('CHIỀU ', CHUYEN_THAPPHAN_SANG_PHANSO(CHIEU_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS CHIEU_UONG,
               CASE
                 WHEN TOI_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('TỐI ', CHUYEN_THAPPHAN_SANG_PHANSO(TOI_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS TOI_UONG,
               CASE GHI_CHU_CT_TOA_THUOC
                 WHEN NULL THEN
                  ''
                 WHEN '' THEN
                  ''
                 ELSE
                  CONCAT('GHI CHÚ: ', GHI_CHU_CT_TOA_THUOC)
               END AS GHI_CHU_CT_TOA_THUOC,
               CT.MA_TOA_THUOC,
               SUM(SO_LUONG) AS SO_LUONG,
               MA_BAC_SI_THEMTHUOC,
               SUM(SO_LUONG_THUC_LINH) AS SO_LUONG_THUC_LINH,
               SUM(THANHTIEN_THUOC) AS THANHTIEN_THUOC,
               CASE CACH_SU_DUNG
                 WHEN NULL THEN
                  ''
                 WHEN '' THEN
                  ''
                 ELSE
                  '( ' || CACH_SU_DUNG || ' )'
               END AS CACH_SU_DUNG,
               CASE GHI_CHU_CT_TOA_THUOC
                 WHEN NULL THEN
                  ''
                 WHEN '' THEN
                  ''
                 ELSE
                  CONCAT(GHI_CHU_CT_TOA_THUOC, ' :')
               END AS GHI_CHU_CT_TOA_THUOC1,
               P_COUNTBS AS TT,
               HIS_MANAGER.HIENTHI_TUOI_BENHNHAN(BN.NGAY_SINH) AS TUOI,
               NVL(V_NGUOILIENHE, ' ') AS NGUOILIENHE,
               CASE V_thamso_82833 WHEN 1 THEN NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                WHEN 2 THEN  NVL(NV.SODIENTHOAI_NHANVIEN, NVL(DMDV.SODIENTHOAI, ' '))
                WHEN 3 THEN NVL(DMDV.SODIENTHOAI, NVL(NV.SODIENTHOAI_NHANVIEN, ' '))
                ELSE NVL(DMDV.SODIENTHOAI, ' ') END AS SODIENTHOAI,
               NVL(V_CMND, ' ') AS SOCMT,
               V_SOTHEBHYT SOTHEBHYT
               ,gskgg.STT_GOISO as stt_goiso
          FROM TMP_KB_CTTT CT
        -- AN GIANG B? SUNG
          LEFT JOIN KB_TOA_THUOC TOA
            ON TOA.MA_TOA_THUOC = CT.MA_TOA_THUOC
           AND TOA.DVTT = P_DVTT
           AND TOA.SOVAOVIEN = CT.SOVAOVIEN
          LEFT JOIN KB_TIEP_NHAN TN
            ON TN.SOVAOVIEN = CT.SOVAOVIEN
           AND TN.DVTT = P_DVTT
          LEFT JOIN KB_KHAM_BENH KB
            ON CT.MA_KHAM_BENH = KB.MA_KHAM_BENH
           AND CT.SOVAOVIEN = KB.SOVAOVIEN
           AND KB.DVTT = P_DVTT
        --LEFT JOIN AGG_KB_NGOAITRU_THILUC THL ON CT.ID_TIEPNHAN = THL.ID_TIEPNHAN AND CT.MABENHNHAN = THL.MA_BENH_NHAN AND THL.DVTT = P_DVTT
          LEFT JOIN HIS_FW.DM_DONVI DMDV
            ON DMDV.MA_DONVI = TN.DVTT
          left join HIS_MANAGER.GOI_SO_KGG gskgg ON gskgg.SOVAOVIEN = KB.SOVAOVIEN and gskgg.dvtt=p_dvtt and gskgg.NGHIEP_VU = 'duoc'
        -- AN GIANG B? SUNG
         , DC_TB_VATTU VT, HIS_FW.DM_NHANVIEN NV,
         HIS_PUBLIC_LIST.DM_BENH_NHAN BN, HIS_FW.DM_HETHONGQUANLY HTQL
         WHERE CT.MA_TOA_THUOC = P_MA_TOA_THUOC
           AND CT.NGHIEP_VU = P_NGHIEP_VU
           AND HTQL.MA_HETHONG = P_DVTT
           AND HTQL.MA_HETHONG = CT.DVTT
           AND CT.DVTT = P_DVTT
           AND CT.MAVATTU = VT.MAVATTU
           AND VT.DVTT = P_DVTT
           AND NV.MA_NHANVIEN = CT.MA_BAC_SI_THEMTHUOC
           AND CT.MA_BAC_SI_THEMTHUOC = (CASE
                 WHEN P_MABACSI != '0' THEN
                  P_MABACSI
                 ELSE
                  CAST(CT.MA_BAC_SI_THEMTHUOC AS VARCHAR(11))
               END)
           AND CT.MABENHNHAN = BN.MA_BENH_NHAN
           AND TOA.SOVAOVIEN = V_SOVAOVIEN
           AND TN.SOVAOVIEN = V_SOVAOVIEN
           AND KB.SOVAOVIEN = V_SOVAOVIEN
         GROUP BY NV.TEN_NHANVIEN,
                  VT.DVT,
                  TENVATTU,
                  SANG_UONG,
                  TRUA_UONG,
                  CHIEU_UONG,
                  TOI_UONG,
                  GHI_CHU_CT_TOA_THUOC,
                  CT.MA_TOA_THUOC,
                  MA_BAC_SI_THEMTHUOC,
                  CACH_SU_DUNG,
                  CT.STT_ORDER,
                  HTQL.TEN_HETHONG,
                  VT.MALOAIHINH,
                  BN.TUOI,
                  BN.NGUOI_LIEN_HE,
                  VT.HOATCHAT,
                  VT.HAMLUONG,
                  CT.NGHIEP_VU,
                  BN.MA_BENH_NHAN,
                  CT.SOPHIEUTHANHTOAN,
                  DMDV.TEN_DONVI,
                  TOA.TEN_PHONG_INTOA,
                  KB.NGAY_HEN,
                  TOA.LOI_DAN_TOA_THUOC,
                  TOA.LOI_DAN_TOA_VATTU_BHYT,
                  TOA.LOI_DAN_TOA_THUOC_MUANGOAI,
                  TOA.LOI_DAN_TOA_THUOC_MIENPHI,
                  TOA.LOI_DAN_TOA_THUOC_MUATAIQUAYBV,
                  TOA.LOI_DAN_TOA_DICHVU_NGOAITRU,
                  TOA.LOI_DAN_TOA_DONGY,
                  VT.TENVATTUHIENTHI,
                  BN.NGAY_SINH,
                  DMDV.SODIENTHOAI,
                  V_CMND,
                  V_NGUOILIENHE,
                  V_SOTHEBHYT,
                  NV.SODIENTHOAI_NHANVIEN
                  ,gskgg.STT_GOISO
        HAVING SUM(SO_LUONG) > 0
         ORDER BY STT_ORDER ASC;
    END IF;
    -- AGG QUÍ 29/06/2016 B? SUNG THÊM THÔNG TIN TRÊN TOA TT05: MABN, SOPHIEU,KCB BAN DAU, LOI DAN, NGAY HEN
  ELSE
    SELECT DECODE(NVL(V_BHXH_BNTRA, 0), 0, 0, NVL(V_PHANTRAMBH, 0))
      INTO V_PHANTRAMBH
      FROM DUAL;
    IF (P_NGHIEP_VU = 'ngoaitru_toathuoc') THEN
      IF V_THAMSO820124 = 1 THEN
        SELECT COUNT(DISTINCT MA_BAC_SI_THEMTHUOC)
          INTO P_COUNTBS
          FROM TMP_KB_CTTT
         WHERE DVTT = P_DVTT
           AND MA_TOA_THUOC = P_MA_TOA_THUOC
           AND UPPER(NGHIEP_VU) IN ('NGOAITRU_TOATHUOC');
        OPEN CUR FOR
          SELECT V_PHANTRAMBH AS TILE,
                 HTQL.TEN_HETHONG,
                 TN.STT_HANGNGAY AS STT_HANGNGAY,
                 MIN(CT.STT_ORDER) AS STT_ORDER,
                 NVTN.TEN_NHANVIEN AS NVTIEPNHAN,
                 CONCAT('BÁC SĨ CHỈ ĐỊNH THUỐC: ', NV.TEN_NHANVIEN) AS TEN_NHANVIEN,
                 VT.DVT,
                 UPPER(VT.TENVATTU) AS TENVATTU,
                 UPPER(VT.HOATCHAT) AS HOATCHAT,
                 -- CASE WHEN VT.MALOAIHINH = 5005 THEN UPPER(VT.TENVATTU) WHEN V_THAMSO=1 THEN CASE WHEN TRIM(VT.HOATCHAT) IS NULL THEN CONCAT(UPPER(VT.TENVATTU) ||' ' ||VT.HAMLUONG ||' (' ||VT.TENVATTU, ')') ELSE UPPER(SUBSTR(VT.HOATCHAT,1,1))||LOWER(SUBSTR(VT.HOATCHAT,2)) ||' ' ||VT.HAMLUONG ||' (' ||VT.TENVATTU|| ')' ELSE CONCAT(UPPER(VT.TENVATTU) ||' ' ||VT.HAMLUONG  END AS MOTA_CHITIET1,
                 CASE
                   WHEN VT.MALOAIHINH = 5005 THEN
                    UPPER(VT.TENVATTU)
                   ELSE
                    UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG
                 END AS MOTA_CHITIET,
                 CASE V_THAMSO
                   WHEN 1 THEN
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                 VT.TENVATTU,
                                 ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || VT.TENVATTU || ') ' ||
                          VT.HAMLUONG
                       END)
                      ELSE
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                 VT.TENVATTU,
                                 ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                          VT.TENVATTU || ') ' || VT.HAMLUONG
                       END)
                    END
                   WHEN 2 THEN
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       CASE
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(VT.HOATCHAT) || ' ' || ' (' || VT.TENVATTU || ') ' ||
                          VT.HAMLUONG
                       END
                      ELSE
                       CASE
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                         -- Y/C CỦA ĐƠN VỊ DAKLAK 66008 HIỂN THỊ TÊN VẬT TƯ CÓ HOẠT CHẤT SAU TÊN THUỐC NẾU LÀ ĐƠN CHẤT. ĐA CHẤT KHÔNG IN HOẠT CHẤT. . TGGDEV-32808
                          CASE
                            WHEN P_DVTT = '66008' THEN
                             CASE
                               WHEN VT.HOATCHAT LIKE '%+%' OR VT.HOATCHAT LIKE '%,%' THEN
                                UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG
                               ELSE
                                UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                VT.HOATCHAT || ')'
                             END
                            ELSE
                             UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                             VT.HOATCHAT || ')'
                          END
                       END
                    END
                   WHEN 5 THEN
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' (' || VT.TENVATTU, ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || VT.TENVATTU || ')'
                       END)
                      ELSE
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' (' || VT.TENVATTU, ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || VT.TENVATTU || ')'
                       END)
                    END
                 -- END VLG
                   WHEN 6 THEN
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                 VT.TENVATTU,
                                 ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                          VT.TENVATTU || ') ' || VT.HAMLUONG
                       END)
                      ELSE
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                 VT.TENVATTU,
                                 ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                          VT.TENVATTU || ') ' || VT.HAMLUONG
                       END)
                    END
                 --V_THAMSO = 7 : HOAT CHAT LA DA CHAT THI K IN RA
                   WHEN 7 THEN
                    CASE
                      when REGEXP_INSTR(vt.HoatChat, '[,+;]') = '0' then
                       UPPER(vt.TenVatTu) || ' ' || vt.HamLuong || ' (' ||
                       vt.hoatchat || ')'
                      else
                       UPPER(vt.TenVatTu) || ' ' || vt.HamLuong
                    END
                 --END V_THAMSO = 7
                   ELSE
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       CASE
                         WHEN VT.MALOAIHINH = 5006 THEN
                          case when p_dvtt = '86080' then UPPER(VT.TEN_HIEN_THI) else VT.TEN_HIEN_THI end -- VLG
                         WHEN VT.MALOAIHINH = 5005 THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          (CASE
                            WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                             CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                    VT.TENVATTU,
                                    ')')
                            WHEN VT.MALOAIHINH = '5005' THEN
                             UPPER(VT.TENVATTU)
                            ELSE
                             UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                             LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                             VT.TENVATTU || ') ' || VT.HAMLUONG
                          END)
                       END
                      ELSE
                       CASE
                         WHEN VT.MALOAIHINH = 5006 THEN
                          case when p_dvtt = '86080' then UPPER(VT.TEN_HIEN_THI) else VT.TEN_HIEN_THI end -- VLG
                         WHEN VT.MALOAIHINH = 5005 THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG
                       END
                    END
                 END AS MOTA_CHITIET1,
                 CASE
                   WHEN SUM(CT.SO_LUONG) < 10 THEN
                    'SL: ' || '0' ||
                    CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                         VARCHAR2(500)) || CONCAT(' ', VT.DVT) || ' ' || ''
                   ELSE
                    'SL: ' || CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                                   VARCHAR2(500)) || ' ' || VT.DVT || ' ' || ''
                 END AS SO_LUONG_UONG,
                 CASE
                   WHEN SANG_UONG = 0 THEN
                    NULL
                   ELSE
                    'SÁNG ' || CHUYEN_THAPPHAN_SANG_PHANSO(SANG_UONG) || ' ' ||
                    CACH_SU_DUNG
                 END AS SANG_UONG,
                 CASE
                   WHEN TRUA_UONG = 0 THEN
                    NULL
                   ELSE
                    'TRƯA ' || CHUYEN_THAPPHAN_SANG_PHANSO(TRUA_UONG) || ' ' ||
                    CACH_SU_DUNG
                 END AS TRUA_UONG,
                 CASE
                   WHEN CHIEU_UONG = 0 THEN
                    NULL
                   ELSE
                    'CHIỀU ' || CHUYEN_THAPPHAN_SANG_PHANSO(CHIEU_UONG) || ' ' ||
                    CACH_SU_DUNG
                 END AS CHIEU_UONG,
                 CASE
                   WHEN TOI_UONG = 0 THEN
                    NULL
                   ELSE
                    'TỐI ' || CHUYEN_THAPPHAN_SANG_PHANSO(TOI_UONG) || ' ' ||
                    CACH_SU_DUNG
                 END AS TOI_UONG,
                 CASE GHI_CHU_CT_TOA_THUOC
                   WHEN NULL THEN
                    ''
                   WHEN '' THEN
                    ''
                   ELSE
                    CONCAT('GHI CHÚ: ', GHI_CHU_CT_TOA_THUOC)
                 END AS GHI_CHU_CT_TOA_THUOC,
                 MA_TOA_THUOC,
                 SUM(SO_LUONG) AS SO_LUONG,
                 MA_BAC_SI_THEMTHUOC,
                 SUM(SO_LUONG_THUC_LINH) AS SO_LUONG_THUC_LINH,
                 SUM(THANHTIEN_THUOC) AS THANHTIEN_THUOC,
                 CASE
                   WHEN CACH_SU_DUNG IS NULL THEN
                    ''
                   WHEN CACH_SU_DUNG = ' ' THEN
                    ''
                   ELSE
                    '( ' || CACH_SU_DUNG || ' )'
                 END AS CACH_SU_DUNG,
                 CASE
                   WHEN GHI_CHU_CT_TOA_THUOC IS NULL THEN
                    ''
                   WHEN GHI_CHU_CT_TOA_THUOC = ' ' THEN
                    ''
                   ELSE
                    CONCAT(GHI_CHU_CT_TOA_THUOC, ' :')
                 END AS GHI_CHU_CT_TOA_THUOC1,
                 P_COUNTBS AS TT,
                 BN.TUOI,
                 NVL(V_NGUOILIENHE, ' ') AS NGUOILIENHE,
                 CASE
                   WHEN v_hienthisdt = '1' THEN --KHI LA DV 04XXX THI IN SDT DV. NEU SDT DV = NULL THI IN SDT NHAN VIEN.
                    CASE
                      WHEN NVL(DMDV.SODIENTHOAI, ' ') = ' ' THEN
                       NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                      ELSE
                       NVL(DMDV.SODIENTHOAI, ' ')
                    END
                   ELSE
                    CASE
                      WHEN P_DVTT = '26005' THEN
                       NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                      ELSE
                       CASE V_thamso_82833 WHEN 1 THEN NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                        WHEN 2 THEN  NVL(NV.SODIENTHOAI_NHANVIEN, NVL(DMDV.SODIENTHOAI, ' '))
                        WHEN 3 THEN NVL(DMDV.SODIENTHOAI, NVL(NV.SODIENTHOAI_NHANVIEN, ' '))
                        ELSE NVL(DMDV.SODIENTHOAI, ' ') END
                    END
                 END AS SODIENTHOAI,
                 NVL(V_CMND, ' ') AS SOCMT,
                 V_SOTHEBHYT SOTHEBHYT
                 ,gskgg.STT_GOISO as stt_goiso
            FROM TMP_KB_CTTT CT, KB_TIEP_NHAN TN
            left join HIS_MANAGER.GOI_SO_KGG gskgg ON gskgg.ID_TIEPNHAN = tn.ID_TIEPNHAN and gskgg.dvtt=p_dvtt and gskgg.NGHIEP_VU = 'duoc'
            LEFT JOIN HIS_FW.DM_DONVI DMDV
              ON DMDV.MA_DONVI = TN.DVTT, DC_TB_VATTU VT,
           HIS_FW.DM_NHANVIEN NV, HIS_FW.DM_NHANVIEN NVTN,
           HIS_PUBLIC_LIST.DM_BENH_NHAN BN, HIS_FW.DM_HETHONGQUANLY HTQL
           WHERE MA_TOA_THUOC = P_MA_TOA_THUOC
             AND HTQL.MA_HETHONG = P_DVTT
             AND TN.DVTT = P_DVTT
             AND TN.SOVAOVIEN = P_SOVAOVIEN
             AND HTQL.MA_HETHONG = CT.DVTT
             AND UPPER(CT.NGHIEP_VU) IN ('NGOAITRU_TOATHUOC')
             AND CT.DVTT = P_DVTT
             AND CT.MAVATTU = VT.MAVATTU
             AND VT.DVTT = P_DVTT
             AND NV.MA_NHANVIEN = CT.MA_BAC_SI_THEMTHUOC
             AND NVTN.MA_NHANVIEN = TN.MA_NHAN_VIEN
             AND CT.MA_BAC_SI_THEMTHUOC = (CASE
                   WHEN P_MABACSI != '0' THEN
                    P_MABACSI
                   ELSE
                    CAST(CT.MA_BAC_SI_THEMTHUOC AS VARCHAR(11))
                 END)
             AND CT.MABENHNHAN = BN.MA_BENH_NHAN
             AND CT.SOVAOVIEN = P_SOVAOVIEN
           GROUP BY V_PHANTRAMBH,
                    NVTN.TEN_NHANVIEN,
                    CONCAT('BÁC SĨ CHỈ ĐỊNH THUỐC: ', NV.TEN_NHANVIEN),
                    VT.DVT,
                    TENVATTU,
                    SANG_UONG,
                    TRUA_UONG,
                    CHIEU_UONG,
                    TOI_UONG,
                    GHI_CHU_CT_TOA_THUOC,
                    MA_TOA_THUOC,
                    MA_BAC_SI_THEMTHUOC,
                    CACH_SU_DUNG,
                    CT.STT_ORDER,
                    HTQL.TEN_HETHONG,
                    TN.STT_HANGNGAY,
                    VT.MALOAIHINH,
                    SANG_UONG,
                    TRUA_UONG,
                    CHIEU_UONG,
                    TOI_UONG,
                    GHI_CHU_CT_TOA_THUOC,
                    BN.TUOI,
                    BN.NGUOI_LIEN_HE,
                    VT.HOATCHAT,
                    VT.HAMLUONG,
                    VT.TEN_HIEN_THI,
                    DMDV.SODIENTHOAI,
                    V_CMND,
                    V_SOTHEBHYT,
                    V_NGUOILIENHE,
                    NV.SODIENTHOAI_NHANVIEN
                    ,gskgg.STT_GOISO
          HAVING SUM(SO_LUONG) > 0
           ORDER BY STT_ORDER ASC;
      ELSE
        SELECT COUNT(DISTINCT MA_BAC_SI_THEMTHUOC)
          INTO P_COUNTBS
          FROM TMP_KB_CTTT
         WHERE DVTT = P_DVTT
           AND MA_TOA_THUOC = P_MA_TOA_THUOC
           AND NGHIEP_VU IN ('ngoaitru_toathuoc', 'ngoaitru_toavattu');
        OPEN CUR FOR
          SELECT V_PHANTRAMBH AS TILE,
                 HTQL.TEN_HETHONG,
                 TN.STT_HANGNGAY AS STT_HANGNGAY,
                 MIN(CT.STT_ORDER) AS STT_ORDER,
                 NVTN.TEN_NHANVIEN AS NVTIEPNHAN,
                 CONCAT('BÁC SĨ CHỈ ĐỊNH THUỐC: ', NV.TEN_NHANVIEN) AS TEN_NHANVIEN,
                 --NV.ten_nhanvien TEN_NHANVIEN_CD,
                 GET_TEN_CHUCDANH_NV(CT.MA_BAC_SI_THEMTHUOC) TEN_NHANVIEN_CD,
                 VT.DVT,
                 UPPER(VT.TENVATTU) AS TENVATTU,
                 UPPER(VT.HOATCHAT) AS HOATCHAT,
                 -- CASE WHEN VT.MALOAIHINH = 5005 THEN UPPER(VT.TENVATTU) WHEN V_THAMSO=1 THEN CASE WHEN TRIM(VT.HOATCHAT) IS NULL THEN CONCAT(UPPER(VT.TENVATTU) ||' ' ||VT.HAMLUONG ||' (' ||VT.TENVATTU, ')') ELSE UPPER(SUBSTR(VT.HOATCHAT,1,1))||LOWER(SUBSTR(VT.HOATCHAT,2)) ||' ' ||VT.HAMLUONG ||' (' ||VT.TENVATTU|| ')' ELSE CONCAT(UPPER(VT.TENVATTU) ||' ' ||VT.HAMLUONG  END AS MOTA_CHITIET1,
                 CASE
                   WHEN VT.MALOAIHINH = 5005 THEN
                    UPPER(VT.TENVATTU)
                   ELSE
                    UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG
                 END AS MOTA_CHITIET,
                 CASE V_THAMSO
                   WHEN 1 THEN
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                 VT.TENVATTU,
                                 ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || VT.TENVATTU || ') ' ||
                          VT.HAMLUONG
                       END)
                      ELSE
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                 VT.TENVATTU,
                                 ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                          VT.TENVATTU || ') ' || VT.HAMLUONG
                       END)
                    END
                   WHEN 2 THEN
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       CASE
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(VT.HOATCHAT) || ' ' || ' (' || VT.TENVATTU || ') ' ||
                          VT.HAMLUONG
                       END
                      ELSE
                       CASE
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          CASE
                            WHEN P_DVTT = '66008' THEN
                             CASE
                               WHEN VT.HOATCHAT LIKE '%+%' OR VT.HOATCHAT LIKE '%,%' THEN
                                UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG
                               ELSE
                                UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                VT.HOATCHAT || ')'
                             END
                            ELSE
                             UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                             VT.HOATCHAT || ')'
                          END
                       END
                    END
                   WHEN 5 THEN
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' (' || VT.TENVATTU, ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || VT.TENVATTU || ')'
                       END)
                      ELSE
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' (' || VT.TENVATTU, ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || VT.TENVATTU || ')'
                       END)
                    END
                 -- END VLG
                   WHEN 6 THEN
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                 VT.TENVATTU,
                                 ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                          VT.TENVATTU || ') ' || VT.HAMLUONG
                       END)
                      ELSE
                       (CASE
                         WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                          CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                 VT.TENVATTU,
                                 ')')
                         WHEN VT.MALOAIHINH = '5005' THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                          LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                          VT.TENVATTU || ') ' || VT.HAMLUONG
                       END)
                    END
                 --V_THAMSO = 7 : HOAT CHAT LA DA CHAT THI K IN RA
                   WHEN 7 THEN
                    CASE
                      when REGEXP_INSTR(vt.HoatChat, '[,+;]') = '0' then
                       UPPER(vt.TenVatTu) || ' ' || vt.HamLuong || ' (' ||
                       vt.hoatchat || ')'
                      else
                       UPPER(vt.TenVatTu) || ' ' || vt.HamLuong
                    END
                 --END V_THAMSO = 7
                   ELSE
                    CASE
                      WHEN V_THAMSOTT52 = 1 THEN
                       CASE
                         WHEN VT.MALOAIHINH = 5006 THEN
                          case when p_dvtt = '86080' then UPPER(VT.TEN_HIEN_THI) else VT.TEN_HIEN_THI end -- VLG
                         WHEN VT.MALOAIHINH = 5005 THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          (CASE
                            WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                             CONCAT(UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG || ' (' ||
                                    VT.TENVATTU,
                                    ')')
                            WHEN VT.MALOAIHINH = '5005' THEN
                             UPPER(VT.TENVATTU)
                            ELSE
                             UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                             LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                             VT.TENVATTU || ') ' || VT.HAMLUONG
                          END)
                       END
                      ELSE
                       CASE
                         WHEN VT.MALOAIHINH = 5006 THEN
                          case when p_dvtt = '86080' then UPPER(VT.TEN_HIEN_THI) else VT.TEN_HIEN_THI end -- VLG
                         WHEN VT.MALOAIHINH = 5005 THEN
                          UPPER(VT.TENVATTU)
                         ELSE
                          UPPER(VT.TENVATTU) || ' ' || VT.HAMLUONG
                       END
                    END
                 END AS MOTA_CHITIET1,
                 CASE
                   WHEN SUM(CT.SO_LUONG) < 10 THEN
                    'SL: ' || '0' ||
                    CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                         VARCHAR2(500)) || CONCAT(' ', VT.DVT) || ' ' || ''
                   ELSE
                    'SL: ' || CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                                   VARCHAR2(500)) || ' ' || VT.DVT || ' ' || ''
                 END AS SO_LUONG_UONG,
                 CASE
                   WHEN SANG_UONG = 0 THEN
                    NULL
                   ELSE
                    'SÁNG ' || CHUYEN_THAPPHAN_SANG_PHANSO(SANG_UONG) || ' ' ||
                    CACH_SU_DUNG
                 END AS SANG_UONG,
                 CASE
                   WHEN TRUA_UONG = 0 THEN
                    NULL
                   ELSE
                    'TRƯA ' || CHUYEN_THAPPHAN_SANG_PHANSO(TRUA_UONG) || ' ' ||
                    CACH_SU_DUNG
                 END AS TRUA_UONG,
                 CASE
                   WHEN CHIEU_UONG = 0 THEN
                    NULL
                   ELSE
                    'CHIỀU ' || CHUYEN_THAPPHAN_SANG_PHANSO(CHIEU_UONG) || ' ' ||
                    CACH_SU_DUNG
                 END AS CHIEU_UONG,
                 CASE
                   WHEN TOI_UONG = 0 THEN
                    NULL
                   ELSE
                    'TỐI ' || CHUYEN_THAPPHAN_SANG_PHANSO(TOI_UONG) || ' ' ||
                    CACH_SU_DUNG
                 END AS TOI_UONG,
                 CASE GHI_CHU_CT_TOA_THUOC
                   WHEN NULL THEN
                    ''
                   WHEN '' THEN
                    ''
                   ELSE
                    CONCAT('GHI CHÚ: ', GHI_CHU_CT_TOA_THUOC)
                 END AS GHI_CHU_CT_TOA_THUOC,
                 MA_TOA_THUOC,
                 SUM(SO_LUONG) AS SO_LUONG,
                 MA_BAC_SI_THEMTHUOC,
                 SUM(SO_LUONG_THUC_LINH) AS SO_LUONG_THUC_LINH,
                 SUM(THANHTIEN_THUOC) AS THANHTIEN_THUOC,
                 CASE
                   WHEN CACH_SU_DUNG IS NULL THEN
                    ''
                   WHEN CACH_SU_DUNG = ' ' THEN
                    ''
                   ELSE
                    '( ' || CACH_SU_DUNG || ' )'
                 END AS CACH_SU_DUNG,
                 CASE
                   WHEN GHI_CHU_CT_TOA_THUOC IS NULL THEN
                    ''
                   WHEN GHI_CHU_CT_TOA_THUOC = ' ' THEN
                    ''
                   ELSE
                    CONCAT(GHI_CHU_CT_TOA_THUOC, ' :')
                 END AS GHI_CHU_CT_TOA_THUOC1,
                 P_COUNTBS AS TT,
                 BN.TUOI,
                 NVL(V_NGUOILIENHE, ' ') AS NGUOILIENHE,
                  CASE
                   WHEN v_hienthisdt = '1' THEN --KHI LA DV 04XXX THI IN SDT DV. NEU SDT DV = NULL THI IN SDT NHAN VIEN.
                    CASE
                      WHEN NVL(DMDV.SODIENTHOAI, ' ') = ' ' THEN
                       NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                      ELSE
                       NVL(DMDV.SODIENTHOAI, ' ')
                    END
                   ELSE
                    CASE
                      WHEN P_DVTT = '26005' THEN
                       NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                      ELSE
                        CASE V_thamso_82833 WHEN 1 THEN NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                        WHEN 2 THEN  NVL(NV.SODIENTHOAI_NHANVIEN, NVL(DMDV.SODIENTHOAI, ' '))
                        WHEN 3 THEN NVL(DMDV.SODIENTHOAI, NVL(NV.SODIENTHOAI_NHANVIEN, ' '))
                        ELSE NVL(DMDV.SODIENTHOAI, ' ') END
                    END
                 END AS SODIENTHOAI,
                 NVL(V_CMND, ' ') AS SOCMT,
                 V_SOTHEBHYT SOTHEBHYT
                 ,gskgg.STT_GOISO as stt_goiso
            FROM TMP_KB_CTTT CT, KB_TIEP_NHAN TN
            left join HIS_MANAGER.GOI_SO_KGG gskgg ON gskgg.ID_TIEPNHAN = tn.ID_TIEPNHAN and gskgg.dvtt=p_dvtt and gskgg.NGHIEP_VU = 'duoc'
            LEFT JOIN HIS_FW.DM_DONVI DMDV
              ON DMDV.MA_DONVI = TN.DVTT, DC_TB_VATTU VT,
           HIS_FW.DM_NHANVIEN NV, HIS_FW.DM_NHANVIEN NVTN,
           HIS_PUBLIC_LIST.DM_BENH_NHAN BN, HIS_FW.DM_HETHONGQUANLY HTQL
           WHERE MA_TOA_THUOC = P_MA_TOA_THUOC
             AND HTQL.MA_HETHONG = P_DVTT
             AND TN.DVTT = P_DVTT
             AND TN.SOVAOVIEN = P_SOVAOVIEN
             AND HTQL.MA_HETHONG = CT.DVTT
             AND CT.NGHIEP_VU IN ('ngoaitru_toathuoc', 'ngoaitru_toavattu')
             AND CT.DVTT = P_DVTT
             AND CT.MAVATTU = VT.MAVATTU
             AND VT.DVTT = P_DVTT
             AND NV.MA_NHANVIEN = CT.MA_BAC_SI_THEMTHUOC
             AND NVTN.MA_NHANVIEN = TN.MA_NHAN_VIEN
             AND CT.MA_BAC_SI_THEMTHUOC = (CASE
                   WHEN P_MABACSI != '0' THEN
                    P_MABACSI
                   ELSE
                    CAST(CT.MA_BAC_SI_THEMTHUOC AS VARCHAR(11))
                 END)
             AND CT.MABENHNHAN = BN.MA_BENH_NHAN
             AND CT.SOVAOVIEN = P_SOVAOVIEN
           GROUP BY V_PHANTRAMBH,
                    NVTN.TEN_NHANVIEN,
                    CONCAT('BÁC SĨ CHỈ ĐỊNH THUỐC: ', NV.TEN_NHANVIEN),
                    NV.ten_nhanvien,
                    VT.DVT,
                    TENVATTU,
                    SANG_UONG,
                    TRUA_UONG,
                    CHIEU_UONG,
                    TOI_UONG,
                    GHI_CHU_CT_TOA_THUOC,
                    MA_TOA_THUOC,
                    MA_BAC_SI_THEMTHUOC,
                    CACH_SU_DUNG,
                    CT.STT_ORDER,
                    HTQL.TEN_HETHONG,
                    TN.STT_HANGNGAY,
                    VT.MALOAIHINH,
                    SANG_UONG,
                    TRUA_UONG,
                    CHIEU_UONG,
                    TOI_UONG,
                    GHI_CHU_CT_TOA_THUOC,
                    BN.TUOI,
                    BN.NGUOI_LIEN_HE,
                    VT.HOATCHAT,
                    VT.HAMLUONG,
                    VT.TEN_HIEN_THI,
                    DMDV.SODIENTHOAI,
                    V_CMND,
                    V_SOTHEBHYT,
                    V_NGUOILIENHE,
                    NV.SODIENTHOAI_NHANVIEN
                    ,gskgg.STT_GOISO
          HAVING SUM(SO_LUONG) > 0
           ORDER BY STT_ORDER ASC;
      END IF;
    ELSE
      SELECT COUNT(DISTINCT MA_BAC_SI_THEMTHUOC)
        INTO P_COUNTBS
        FROM TMP_KB_CTTT
       WHERE DVTT = P_DVTT
         AND MA_TOA_THUOC = P_MA_TOA_THUOC
         AND NGHIEP_VU = P_NGHIEP_VU;
      OPEN CUR FOR
        SELECT V_PHANTRAMBH AS TILE,
               HTQL.TEN_HETHONG,
               TN.STT_HANGNGAY AS STT_HANGNGAY,
               MIN(CT.STT_ORDER) AS STT_ORDER,
               NVTN.TEN_NHANVIEN AS NVTIEPNHAN,
               CONCAT('BÁC SĨ CHỈ ĐỊNH THUỐC: ', NV.TEN_NHANVIEN) AS TEN_NHANVIEN,
               --NV.ten_nhanvien TEN_NHANVIEN_CD,
               GET_TEN_CHUCDANH_NV(CT.MA_BAC_SI_THEMTHUOC) TEN_NHANVIEN_CD,
               VT.DVT,
               UPPER(VT.TENVATTU) AS TENVATTU,
               UPPER(VT.HOATCHAT) AS HOATCHAT,
               -- CASE WHEN VT.HOATCHAT !='' THEN CONCAT(CONCAT(UPPER(VT.HOATCHAT),' (',VT.TENVATTU), ')') ELSE UPPER(VT.TENVATTU) END AS MOTA_CHITIET,
               CASE
                 WHEN VT.MALOAIHINH = 5005 THEN
                  case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                 ELSE
                  case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end  || ' ' || VT.HAMLUONG
               END AS MOTA_CHITIET,
               CASE V_THAMSO
                 WHEN 1 THEN
                  CASE
                    WHEN V_THAMSOTT52 = 1 THEN
                     (CASE
                       WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                        CONCAT(case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG || ' (' ||
                               case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end,
                               ')')
                       WHEN VT.MALOAIHINH = '5005' THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                        LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end || ') ' ||
                        VT.HAMLUONG
                     END)
                    ELSE
                     (CASE
                       WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                        CONCAT(case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG || ' (' ||
                               case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end,
                               ')')
                       WHEN VT.MALOAIHINH = '5005' THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                        LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end || ') ' || VT.HAMLUONG
                     END)
                  END
                 WHEN 2 THEN
                  CASE
                    WHEN V_THAMSOTT52 = 1 THEN
                     CASE
                       WHEN VT.MALOAIHINH = '5005' THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        UPPER(VT.HOATCHAT) || ' ' || ' (' || case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end || ') ' ||
                        VT.HAMLUONG
                     END
                    ELSE
                     CASE
                       WHEN VT.MALOAIHINH = '5005' THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        CASE
                          WHEN P_DVTT = '66008' THEN
                           CASE
                             WHEN VT.HOATCHAT LIKE '%+%' OR VT.HOATCHAT LIKE '%,%' THEN
                              case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG
                             ELSE
                              case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG || ' (' ||
                              VT.HOATCHAT || ')'
                           END
                          ELSE
                           case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG || ' (' ||
                           VT.HOATCHAT || ')'
                        END
                     END
                  END
                 WHEN 5 THEN
                  CASE
                    WHEN V_THAMSOTT52 = 1 THEN
                     (CASE
                       WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                        CONCAT(case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' (' || case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end, ')')
                       WHEN VT.MALOAIHINH = '5005' THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                        LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end || ')'
                     END)
                    ELSE
                     (CASE
                       WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                        CONCAT(case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' (' || VT.TENVATTU, ')')
                       WHEN VT.MALOAIHINH = '5005' THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                        LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' (' || case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end || ')'
                     END)
                  END
               -- END VLG
                 WHEN 6 THEN
                  CASE
                    WHEN V_THAMSOTT52 = 1 THEN
                     (CASE
                       WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                        CONCAT(case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG || ' (' ||
                               case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end,
                               ')')
                       WHEN VT.MALOAIHINH = '5005' THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                        LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end || ') ' || VT.HAMLUONG
                     END)
                    ELSE
                     (CASE
                       WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                        CONCAT(case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG || ' (' ||
                               case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end,
                               ')')
                       WHEN VT.MALOAIHINH = '5005' THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                        LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end || ') ' || VT.HAMLUONG
                     END)
                  END
               --V_THAMSO = 7 : HOAT CHAT LA DA CHAT THI K IN RA
                 WHEN 7 THEN
                  CASE
                    when REGEXP_INSTR(vt.HoatChat, '[,+;]') = '0' then
                     case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || vt.HamLuong || ' (' ||
                     vt.hoatchat || ')'
                    else
                     case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || vt.HamLuong
                  END
               --END V_THAMSO = 7
                 ELSE
                  CASE
                    WHEN V_THAMSOTT52 = 1 THEN
                     CASE
                       WHEN VT.MALOAIHINH = 5006 THEN
                        case when p_dvtt = '86080' then UPPER(VT.TEN_HIEN_THI) else VT.TEN_HIEN_THI end-- VLG
                       WHEN VT.MALOAIHINH = 5005 THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        (CASE
                          WHEN TRIM(VT.HOATCHAT) IS NULL THEN
                           CONCAT(case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG || ' (' ||
                                  case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi else VT.TENVATTU end,
                                  ')')
                          WHEN VT.MALOAIHINH = '5005' THEN
                           case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                          ELSE
                           UPPER(SUBSTR(VT.HOATCHAT, 1, 1)) ||
                           LOWER(SUBSTR(VT.HOATCHAT, 2)) || ' ' || ' (' ||
                           case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then vt.ten_hien_thi  else VT.TENVATTU end || ') ' || VT.HAMLUONG
                        END)
                     END
                    ELSE
                     CASE
                       WHEN VT.MALOAIHINH = 5006 THEN
                        case when p_dvtt = '86080' then UPPER(VT.TEN_HIEN_THI) else VT.TEN_HIEN_THI end -- VLG
                       WHEN VT.MALOAIHINH = 5005 THEN
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end
                       ELSE
                        case when v_tenht_toadv_82431 = 1 and length(vt.ten_hien_thi) > 2 then UPPER(vt.ten_hien_thi)  else UPPER(VT.TENVATTU) end || ' ' || VT.HAMLUONG
                     END
                  END
               END AS MOTA_CHITIET1,
               CASE
                 WHEN SUM(CT.SO_LUONG) < 10 THEN
                  'SL: ' ||
                  CONCAT('0',
                         CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                              VARCHAR2(500))) || CONCAT(' ', VT.DVT) || ' ' || ''
                 ELSE
                  'SL: ' || CAST(CAST(SUM(CT.SO_LUONG) AS NUMBER(18, 0)) AS
                                 VARCHAR2(500)) || CONCAT(' ', VT.DVT) || ' ' || ''
               END AS SO_LUONG_UONG,
               CASE
                 WHEN SANG_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('SÁNG ', CHUYEN_THAPPHAN_SANG_PHANSO(SANG_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS SANG_UONG,
               CASE
                 WHEN TRUA_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('TRƯA ', CHUYEN_THAPPHAN_SANG_PHANSO(TRUA_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS TRUA_UONG,
               CASE
                 WHEN CHIEU_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('CHIỀU ', CHUYEN_THAPPHAN_SANG_PHANSO(CHIEU_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS CHIEU_UONG,
               CASE
                 WHEN TOI_UONG = 0 THEN
                  NULL
                 ELSE
                  CONCAT('TỐI ', CHUYEN_THAPPHAN_SANG_PHANSO(TOI_UONG)) || ' ' ||
                  CACH_SU_DUNG
               END AS TOI_UONG,
               CASE GHI_CHU_CT_TOA_THUOC
                 WHEN NULL THEN
                  ''
                 WHEN '' THEN
                  ''
                 ELSE
                  CONCAT('GHI CHÚ: ', GHI_CHU_CT_TOA_THUOC)
               END AS GHI_CHU_CT_TOA_THUOC,
               MA_TOA_THUOC,
               SUM(SO_LUONG) AS SO_LUONG,
               MA_BAC_SI_THEMTHUOC,
               SUM(SO_LUONG_THUC_LINH) AS SO_LUONG_THUC_LINH,
               SUM(THANHTIEN_THUOC) AS THANHTIEN_THUOC,
               CASE
                 WHEN CACH_SU_DUNG IS NULL THEN
                  ''
                 WHEN CACH_SU_DUNG = ' ' THEN
                  ''
                 ELSE
                  '( ' || CACH_SU_DUNG || ' )'
               END AS CACH_SU_DUNG,
               CASE
                 WHEN GHI_CHU_CT_TOA_THUOC IS NULL THEN
                  ''
                 WHEN GHI_CHU_CT_TOA_THUOC = ' ' THEN
                  ''
                 ELSE
                  CONCAT(GHI_CHU_CT_TOA_THUOC, ' :')
               END AS GHI_CHU_CT_TOA_THUOC1,
               P_COUNTBS AS TT,
               BN.TUOI,
               NVL(V_NGUOILIENHE, ' ') AS NGUOILIENHE,
               CASE
                   WHEN v_hienthisdt = '1' THEN --KHI LA DV 04XXX THI IN SDT DV. NEU SDT DV = NULL THI IN SDT NHAN VIEN.
                    CASE
                      WHEN NVL(DMDV.SODIENTHOAI, ' ') = ' ' THEN
                       NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                      ELSE
                       NVL(DMDV.SODIENTHOAI, ' ')
                    END
                   ELSE
                    CASE
                      WHEN P_DVTT = '26005' THEN
                       NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                      ELSE
                        CASE V_thamso_82833 WHEN 1 THEN NVL(NV.SODIENTHOAI_NHANVIEN, ' ')
                          WHEN 2 THEN  NVL(NV.SODIENTHOAI_NHANVIEN, NVL(DMDV.SODIENTHOAI, ' '))
                          WHEN 3 THEN NVL(DMDV.SODIENTHOAI, NVL(NV.SODIENTHOAI_NHANVIEN, ' '))
                          ELSE NVL(DMDV.SODIENTHOAI, ' ') END
                    END
                 END AS SODIENTHOAI,
               NVL(V_CMND, ' ') AS SOCMT,
               V_SOTHEBHYT SOTHEBHYT
               ,gskgg.STT_GOISO as stt_goiso
          FROM TMP_KB_CTTT CT, KB_TIEP_NHAN TN
          left join HIS_MANAGER.GOI_SO_KGG gskgg ON gskgg.ID_TIEPNHAN = tn.ID_TIEPNHAN and GSKGG.DVTT=p_dvtt and gskgg.NGHIEP_VU = 'duoc'
          LEFT JOIN HIS_FW.DM_DONVI DMDV
            ON DMDV.MA_DONVI = TN.DVTT, DC_TB_VATTU VT, HIS_FW.DM_NHANVIEN NV,
         HIS_FW.DM_NHANVIEN NVTN, HIS_PUBLIC_LIST.DM_BENH_NHAN BN,
         HIS_FW.DM_HETHONGQUANLY HTQL
         WHERE MA_TOA_THUOC = P_MA_TOA_THUOC
           AND CT.NGHIEP_VU = P_NGHIEP_VU
           AND HTQL.MA_HETHONG = P_DVTT
           AND HTQL.MA_HETHONG = CT.DVTT
           AND TN.DVTT = P_DVTT
           AND CT.DVTT = P_DVTT
           AND CT.MAVATTU = VT.MAVATTU
           AND VT.DVTT = P_DVTT
           AND NV.MA_NHANVIEN = CT.MA_BAC_SI_THEMTHUOC
           AND TN.SOVAOVIEN = CT.SOVAOVIEN
           AND NVTN.MA_NHANVIEN = TN.MA_NHAN_VIEN
           AND CT.MA_BAC_SI_THEMTHUOC = (CASE
                 WHEN NVL(P_MABACSI, 0) != '0' THEN
                  P_MABACSI
                 ELSE
                  CAST(CT.MA_BAC_SI_THEMTHUOC AS VARCHAR2(11))
               END)
           AND CT.MABENHNHAN = BN.MA_BENH_NHAN
           AND CT.SOVAOVIEN = P_SOVAOVIEN
         GROUP BY V_PHANTRAMBH,
                  NVTN.TEN_NHANVIEN,
                  CONCAT('BÁC SĨ CHỈ ĐỊNH THUỐC: ', NV.TEN_NHANVIEN),
                  NV.ten_nhanvien,
                  VT.DVT,
                  TENVATTU,
                  SANG_UONG,
                  TRUA_UONG,
                  CHIEU_UONG,
                  TOI_UONG,
                  GHI_CHU_CT_TOA_THUOC,
                  MA_TOA_THUOC,
                  MA_BAC_SI_THEMTHUOC,
                  TN.STT_HANGNGAY,
                  CACH_SU_DUNG,
                  CT.STT_ORDER,
                  HTQL.TEN_HETHONG,
                  VT.MALOAIHINH,
                  SANG_UONG,
                  TRUA_UONG,
                  CHIEU_UONG,
                  TOI_UONG,
                  GHI_CHU_CT_TOA_THUOC,
                  BN.TUOI,
                  BN.NGUOI_LIEN_HE,
                  VT.HOATCHAT,
                  VT.HAMLUONG,
                  VT.TEN_HIEN_THI,
                  DMDV.SODIENTHOAI,
                  V_CMND,
                  V_SOTHEBHYT,
                  V_NGUOILIENHE,
                  NV.SODIENTHOAI_NHANVIEN
                  ,gskgg.STT_GOISO
        HAVING SUM(SO_LUONG) > 0
         ORDER BY STT_ORDER ASC;
    END IF;
  END IF;
END;
