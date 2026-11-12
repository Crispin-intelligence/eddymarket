SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [DateTimes].[f_DateTimeDiff](
@DateBegin datetime , 
@DateEnd datetime , 
@PartBegin nvarchar(max)  , 
@WithSonOfPart bit = 0 ,
@IfEqual NVARCHAR(max) = '=',
@IfLarger NVARCHAR(max) = '>'
) returns nvarchar(max)

as

begin

declare @Return nvarchar(max)

if @DateBegin  = @DateEnd begin return @IfEqual  end
if @DateBegin >= @DateEnd begin return @IfLarger end

declare @YearBase   int    = datediff(YEAR,   @DateBegin , @DateEnd)
declare @MonthBase  int    = datediff(MONTH,  @DateBegin , @DateEnd)
declare @DayBase    int    = datediff(DAY,    @DateBegin , @DateEnd)
declare @HourBase   bigint = datediff(HOUR,   @DateBegin , @DateEnd)
declare @MinuteBase bigint = datediff(MINUTE, @DateBegin , @DateEnd)
declare @SecondBase bigint = datediff(SECOND, @DateBegin , @DateEnd)

declare @Year   int    = datediff(YEAR, @DateBegin , @DateEnd)
declare @Month  int    = datediff(MONTH,  dateadd(year,   @YearBase,   @DateBegin) , @DateEnd)
declare @Day    int    = datediff(DAY,    dateadd(MONTH,  @MonthBase,  @DateBegin) , @DateEnd)
declare @Hour   bigint = datediff(HOUR,   dateadd(DAY,    @DayBase,    @DateBegin) , @DateEnd)
declare @Minute bigint = datediff(MINUTE, dateadd(HOUR,   @HourBase,   @DateBegin) , @DateEnd)
declare @Second bigint = datediff(SECOND, dateadd(MINUTE, @MinuteBase, @DateBegin) , @DateEnd)

if @Month  < 0  begin set @Month  = @Month  +12 set @Year   = @Year   -1 end
if @Day    < 0  begin set @Day    = @Day    +30 set @Month  = @Month  -1 end
if @Hour   < 0  begin set @Hour   = @Hour   +24 set @Day    = @Day    -1 end
if @Minute < 0  begin set @Minute = @Minute +60 set @Hour   = @Hour   -1 end
if @Second < 0  begin set @Second = @Second +60 set @Minute = @Minute -1 end


if @WithSonOfPart = 1
	begin
		if @PartBegin like 'y'begin set @Return = 
			 [DateTimes].f_DateTimeDecisionReturn(@Year   , '-'  , 'y' ) + 
			 [DateTimes].f_DateTimeDecisionReturn(@Month  , '-'  , 'm' ) + 
			 [DateTimes].f_DateTimeDecisionReturn(@Day    , ' ' , 'd' ) + 
			 [DateTimes].f_DateTimeDecisionReturn(@Hour   , ':'  , 'h' ) +
			 [DateTimes].f_DateTimeDecisionReturn(@Minute , ':'  , 'mm') +  
			 [DateTimes].f_DateTimeDecisionReturn(@Second , ''   , 's' ) end

		else if @PartBegin like 'm'begin 
			set @Return =  
			 [DateTimes].f_DateTimeDecisionReturn(@Month + (@Year * 12) , '-'  , 'm' ) + 
			 [DateTimes].f_DateTimeDecisionReturn(@Day                  , ' ' , 'd' ) + 
			 [DateTimes].f_DateTimeDecisionReturn(@Hour                 , ':'  , 'h' ) +
			 [DateTimes].f_DateTimeDecisionReturn(@Minute               , ':'  , 'mm') +  
			 [DateTimes].f_DateTimeDecisionReturn(@Second               , ''   , 's' ) end

		else if @PartBegin like 'd' begin
			set @Month = @Month + @Year  * 12
			set @Day   = @Day   + @Month * 30
		 set @Return = 
			 [DateTimes].f_DateTimeDecisionReturn(@Day    , ' ' , 'd' ) + 
			 [DateTimes].f_DateTimeDecisionReturn(@Hour   , ':'  , 'h' ) +
			 [DateTimes].f_DateTimeDecisionReturn(@Minute , ':'  , 'mm') +  
			 [DateTimes].f_DateTimeDecisionReturn(@Second , ''   , 's' ) end

		else if @PartBegin like 'h' begin
			set @Month = @Month + @Year  * 12
			set @Day   = @Day   + @Month * 30
			set @Hour  = @Hour  + @Day   * 24
		 set @Return =  
			 [DateTimes].f_DateTimeDecisionReturn(@Hour   , ':' , 'h' ) +
			 [DateTimes].f_DateTimeDecisionReturn(@Minute , ':' , 'mm') +  
			 [DateTimes].f_DateTimeDecisionReturn(@Second , ''  , 's' ) end

		else if @PartBegin like 'mm' begin
			set @Month  = @Month  + @Year    * 12
			set @Day    = @Day    +   @Month * 30
			set @Hour   = @Hour   + @Day     * 24
			set @Minute = @Minute + @Hour    * 60
		 set @Return =  
			[DateTimes].f_DateTimeDecisionReturn(@Minute , ':' , 'mm') +  
			[DateTimes].f_DateTimeDecisionReturn(@Second , ''  , 's' ) end

		else if @PartBegin like 's' begin
			set @Month  = @Month  + @Year   * 12
			set @Day    = @Day    + @Month  * 30
			set @Hour   = @Hour   + @Day    * 24
			set @Minute = @Minute + @Hour   * 60
			set @Second = @Second + @Minute * 60
		 set @Return =  
			[DateTimes].f_DateTimeDecisionReturn(@Second , '' , 's' ) end 
	end
else
	begin
		set @Month  = @Month  + @Year   *12
		set @Day    = @Day    + @Month  *30
		set @Hour   = @Hour   + @Day    *24
		set @Minute = @Minute + @Hour   *60
		set @Second = @Second + @Minute *60

		if      @PartBegin like 'y'  BEGIN set @Return = [DateTimes].f_DateTimeDecisionReturn(@Year   , '' , 'y') end
														
		else if @PartBegin like 'm'  BEGIN set @Return = [DateTimes].f_DateTimeDecisionReturn(@Month  , '' , 'm')  end
																										 
		else if @PartBegin like 'd'  BEGIN set @Return = [DateTimes].f_DateTimeDecisionReturn(@Day    , '' , 'd')  end
																										
		else if @PartBegin like 'h'  BEGIN set @Return = [DateTimes].f_DateTimeDecisionReturn(@Hour   , '' , 'h') end
																										 
		else if @PartBegin like 'mm' BEGIN set @Return = [DateTimes].f_DateTimeDecisionReturn(@Minute , '' , 'mm') end
																									
		else if @PartBegin like 's'  BEGIN set @Return = [DateTimes].f_DateTimeDecisionReturn(@Second , '' , 's') end

	end

if @Return = '' begin set @Return = '' end

RETURN ISNULL( CAST(REPLACE(LTRIM(@Return) , '  ' , '00:') AS NVARCHAR(MAX)) , N'')
end






GO
