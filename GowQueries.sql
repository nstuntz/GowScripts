-- ets-tfs.cloudapp.net,51710

SELECT [CityID],[Bank],[Rally],[Tent],[RallyX],[RallyY],[TentX],[TentY],[LastRally],[LastBank],[LastUpgrade],[ProductionPerHour],[LastAthenaGift],[StrongHoldLevel],[TreasuryLevel],[Shield],[LastShield],[LastUpgradeBuilding] FROM CityInfo where CityID=7

--update CityInfo set LastRally=GetDate(), LastBank = GetDate(), LastUpgrade = GetDate(), LastAthenaGift=GetDate()

SELECT UserName,Password,LastRun,LoginID,DATEADD(hh,1,LastRun) 
FROM Login where Active = 1 and ( InProcess = 0 or DATEADD(hh,1,LastRun) < GetDate() ) order by LastRun Asc

SELECT [CityID],[LoginID],[CityName],[Kingdom],[LocationX],[LocationY],[Created],[Placed],[ResourceTypeID],[AllianceID] FROM City where LoginID=6


update cityinfo set Shield=1, LastShield=GetDate() where cityid=7

update cityinfo set LastUpgradeBuilding=-1,StrongHoldLevel=14  where cityid=7

select DATEADD(d,-2,LastShield),* from  cityinfo  where cityid=7


update cityinfo set bank=0 where cityid=13

update login set LastRun = GetDate()

select * from login
select * from city where loginid=9
select * from cityinfo where cityid=10



select CityName, username, c.CityID, Strongholdlevel, ResourceTypeID 
from Login l INNER JOIN
	City c on l.loginid=c.loginid INNER JOIN
	CityInfo ci on ci.cityid = c.cityid
	
Update Login Set LastRun = '2014-12-22 22:10:00', inprocess=0 where LoginID = 6	

update City set CityName='1GowGun' where loginid=6