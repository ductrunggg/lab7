--Câu 1
--1a
create function ftuoiNV (@MANV nvarchar(9))
returns int 
as
begin
	return 
	(
	select DATEDIFF(year, NGSINH, GETDATE()) + 1 from NHANVIEN
	where MANV = @MANV
	)
end;
select [dbo].[ftuoiNV] ('007')
select*from NHANVIEN;

--------------------
--1b
create function fdeanNVthamgia (@MANV nvarchar(9))
returns int
as
begin
	return
	(
	select COUNT(mada) from PHANCONG where MA_NVIEN = @MANV
	)
end;
select [dbo].[fdeanNVthamgia] ('007')
select*from PHANCONG;

--------------------
--1c
create function fthongke_phai (@Phai nvarchar(3))
returns int
as
begin
	return(select count(manv) from NHANVIEN where PHAI like @Phai);
end;
select [dbo].[fthongke_phai] (N'Nữ')
select*from NHANVIEN;

--------------------
--1d
create function ftinhluongTB ( @Tenphong nvarchar(30))
returns int
as
begin
	return
	(
	select AVG(b.luong) from PHONGBAN a inner join NHANVIEN b on a.MAPHG = b.PHG
	where TENPHG like '%' + @Tenphong + '%'
	)
end;
select HONV, TENLOT, TENNV from NHANVIEN a inner join PHONGBAN b on a.PHG = b.MAPHG
where luong >[dbo].[ftinhluongTB] (N'Quản lý') and TENPHG like N'%Quản lý%';
select*from PHONGBAN;

--------------------
--1e
create function fthongtinphongdean (@MaPhg int)
returns @list table (TenPhong nvarchar(15), TenTruongPhong nvarchar (30), SoLuongDeAn int)
as
begin
	insert into @list
		select a.TENPHG, b.HONV + ' ' + b.TENLOT + ' ' + b.TENNV,
			(select COUNT(c.MADA) from DEAN c where c.PHONG = a.MAPHG)
			from PHONGBAN a inner join NHANVIEN b on a.MAPHG = b.MANV
			where a.MAPHG = @MaPhg;
	return;
end;
select*from [dbo].[fthongtinphongdean] (1);

--------------------

--Câu 2
--2a
create view vddphongban 
as
select HONV, TENNV, TENPHG, DIADIEM from PHONGBAN
inner join DIADIEM_PHG on DIADIEM_PHG.MAPHG = PHONGBAN.MAPHG
inner join NHANVIEN on NHANVIEN.PHG = PHONGBAN.MAPHG
select*from vddphongban;

--------------------
--2b
create view vthongtincuaNV
as
select TENNV, LUONG, DATEDIFF(year, NGSINH, GETDATE()) as 'Tuoi' from NHANVIEN
select*from vthongtincuaNV;

--------------------
--2c
create view vPBdongNVnhat
as 
select a.TENPHG, b.HONV + ' ' + b.TENLOT + ' ' + b.TENNV as 'Tentruongphong' 
from PHONGBAN a inner join NHANVIEN b on a.TRPHG = b.MANV
where a.MAPHG in(
	select PHG from NHANVIEN
	group by phg
	having COUNT(manv) = 
		(select top 1 COUNT(manv) as NVCount from NHANVIEN
			group by phg
			order by NVCount desc)
	)

select*from vPBdongNVnhat;
