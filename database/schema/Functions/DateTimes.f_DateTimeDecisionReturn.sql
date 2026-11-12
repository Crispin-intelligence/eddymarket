SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [DateTimes].[f_DateTimeDecisionReturn](@Value bigint , @Text nvarchar(max) , @Part nvarchar(max))  returns nvarchar(max)
as
begin
		if @Part like 'y'  begin  return case @Value when 0 then '0000-' else cast(@Value as nvarchar(max)) + @Text + '' end end
		if @Part like 'm'  begin  return case @Value when 0 then '00-'   else cast(@Value as nvarchar(max)) + @Text + '' end end
		if @Part like 'd'  begin  return case @Value when 0 then '00 '   else cast(@Value as nvarchar(max)) + @Text + '' end end
		if @Part like 'h'  begin  return case @Value when 0 then '00:'   else cast(@Value as nvarchar(max)) + @Text + '' end end
		if @Part like 'mm' begin  return case @Value when 0 then '00:'   else cast(@Value as nvarchar(max)) + @Text + '' end end
		if @Part like 's'  begin  return case @Value when 0 then '00'    else cast(@Value as nvarchar(max)) + @Text + '' end end
return ''
END



GO
