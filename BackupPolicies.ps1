$subs=Get-AzSubscription

foreach($sub in $subs){
    $vaults = Get-AzRecoveryServicesVault
    foreach($vault in $vaults){
        Set-AzRecoveryServicesVaultContext -Vault $vault
        $policys = Get-AzRecoveryServicesBackupProtectionPolicy
        foreach($policy in $policys){
            #Write-Host "$($sub.Name)|$($vault.Name)|$($policy.Name)|$($policy.WorkloadType)|$($policy.BackupManagementType)|$($policy.SnapshotRetentionInDays)|$($policy.ProtectedItemsCount)|$($policy.PolicySubType)|$($policy.SchedulePolicy)|$($policy.RetentionPolicy)"
            <#
            Write-Host ">>>>>>>>>>>>>>"
            $policy.SchedulePolicy.ScheduleRunFrequency
            $policy.SchedulePolicy.ScheduleRunDays
            $policy.SchedulePolicy.ScheduleRunTimes
            $policy.SchedulePolicy.ScheduleInterval
            $policy.SchedulePolicy.ScheduleWindowStartTime
            $policy.SchedulePolicy.ScheduleWindowDuration
            $policy.SchedulePolicy.ScheduleRunTimeZone
            Write-Host "<<<<<<<<<<<<<"
            $policy.RetentionPolicy.IsDailyScheduleEnabled
            $policy.RetentionPolicy.IsWeeklyScheduleEnabled
            $policy.RetentionPolicy.IsMonthlyScheduleEnabled
            $policy.RetentionPolicy.IsYearlyScheduleEnabled
            $policy.RetentionPolicy.DailySchedule.DurationCountInDays
            $policy.RetentionPolicy.DailySchedule.RetentionTimes
            $policy.RetentionPolicy.WeeklySchedule.DurationCountInWeeks
            $policy.RetentionPolicy.WeeklySchedule.DaysOfTheWeek
            $policy.RetentionPolicy.WeeklySchedule.RetentionTimes
            $policy.RetentionPolicy.MonthlySchedule.DurationCountInMonths
            $policy.RetentionPolicy.MonthlySchedule.RetentionScheduleType
            $policy.RetentionPolicy.MonthlySchedule.RetentionTimes
            $policy.RetentionPolicy.MonthlySchedule.RetentionScheduleDaily
            $policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.DaysOfTheWeek
            $policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.WeeksOfTheMonth
            $policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.RetentionTimes
            $policy.RetentionPolicy.YearlySchedule.DurationCountInYears
            $policy.RetentionPolicy.YearlySchedule.RetentionScheduleType
            $policy.RetentionPolicy.YearlySchedule.RetentionTimes
            $policy.RetentionPolicy.YearlySchedule.RetentionScheduleDaily
            $policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek
            $policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.WeeksOfTheMonth
            $policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.MonthsOfYear
            $policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.RetentionTimes
            #>
            Write-Host "$($sub.Name),$($vault.Name),$($policy.Name),$($policy.WorkloadType),$($policy.BackupManagementType),$($policy.SnapshotRetentionInDays),$($policy.ProtectedItemsCount),$($policy.PolicySubType),$($policy.SchedulePolicy.ScheduleRunFrequency),$($policy.SchedulePolicy.ScheduleRunDays),$($policy.SchedulePolicy.ScheduleRunTimes),$($policy.SchedulePolicy.ScheduleInterval),$($policy.SchedulePolicy.ScheduleWindowStartTime),$($policy.SchedulePolicy.ScheduleWindowDuration),$($policy.SchedulePolicy.ScheduleRunTimeZone),$($policy.RetentionPolicy.IsDailyScheduleEnabled),$($policy.RetentionPolicy.IsWeeklyScheduleEnabled),$($policy.RetentionPolicy.IsMonthlyScheduleEnabled),$($policy.RetentionPolicy.IsYearlyScheduleEnabled),$($policy.RetentionPolicy.DailySchedule.DurationCountInDays),$($policy.RetentionPolicy.DailySchedule.RetentionTimes),$($policy.RetentionPolicy.WeeklySchedule.DurationCountInWeeks),$($policy.RetentionPolicy.WeeklySchedule.DaysOfTheWeek),$($policy.RetentionPolicy.WeeklySchedule.RetentionTimes),$($policy.RetentionPolicy.MonthlySchedule.DurationCountInMonths),$($policy.RetentionPolicy.MonthlySchedule.RetentionScheduleType),$($policy.RetentionPolicy.MonthlySchedule.RetentionTimes),$($policy.RetentionPolicy.MonthlySchedule.RetentionScheduleDaily),$($policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.DaysOfTheWeek),$($policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.WeeksOfTheMonth),$($policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.RetentionTimes),$($policy.RetentionPolicy.YearlySchedule.DurationCountInYears),$($policy.RetentionPolicy.YearlySchedule.RetentionScheduleType),$($policy.RetentionPolicy.YearlySchedule.RetentionTimes),$($policy.RetentionPolicy.YearlySchedule.RetentionScheduleDaily),$($policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek),$($policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.WeeksOfTheMonth),$($policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.MonthsOfYear),$($policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.RetentionTimes)"
        }
    }
}
Write-Host "sub.Name,vault.Name,policy.Name,policy.WorkloadType,policy.BackupManagementType,policy.SnapshotRetentionInDays,policy.ProtectedItemsCount,policy.PolicySubType,policy.SchedulePolicy.ScheduleRunFrequency,policy.SchedulePolicy.ScheduleRunDays,policy.SchedulePolicy.ScheduleRunTimes,policy.SchedulePolicy.ScheduleInterval,policy.SchedulePolicy.ScheduleWindowStartTime,policy.SchedulePolicy.ScheduleWindowDuration,policy.SchedulePolicy.ScheduleRunTimeZone,policy.RetentionPolicy.IsDailyScheduleEnabled,policy.RetentionPolicy.IsWeeklyScheduleEnabled,policy.RetentionPolicy.IsMonthlyScheduleEnabled,policy.RetentionPolicy.IsYearlyScheduleEnabled,policy.RetentionPolicy.DailySchedule.DurationCountInDays,policy.RetentionPolicy.DailySchedule.RetentionTimes,policy.RetentionPolicy.WeeklySchedule.DurationCountInWeeks,policy.RetentionPolicy.WeeklySchedule.DaysOfTheWeek,policy.RetentionPolicy.WeeklySchedule.RetentionTimes,policy.RetentionPolicy.MonthlySchedule.DurationCountInMonths,policy.RetentionPolicy.MonthlySchedule.RetentionScheduleType,policy.RetentionPolicy.MonthlySchedule.RetentionTimes,policy.RetentionPolicy.MonthlySchedule.RetentionScheduleDaily,policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.DaysOfTheWeek,policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.WeeksOfTheMonth,policy.RetentionPolicy.MonthlySchedule.RetentionScheduleWeekly.RetentionTimes,policy.RetentionPolicy.YearlySchedule.DurationCountInYears,policy.RetentionPolicy.YearlySchedule.RetentionScheduleType,policy.RetentionPolicy.YearlySchedule.RetentionTimes,policy.RetentionPolicy.YearlySchedule.RetentionScheduleDaily,policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.DaysOfTheWeek,policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.WeeksOfTheMonth,policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.MonthsOfYear,policy.RetentionPolicy.YearlySchedule.RetentionScheduleWeekly.RetentionTimes"