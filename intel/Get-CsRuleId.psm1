function Get-CsRuleId {
<#
    .SYNOPSIS
        Search for rule IDs

    .PARAMETER TYPE
        The rule news report type

    .PARAMETER NAME
        Search by rule title

    .PARAMETER DESCRIPTION
        Substring match on description field

    .PARAMETER TAG
        Search for rule tags

    .PARAMETER MINCREATED
        Filter results to those created on or after a certain date

    .PARAMETER MAXCREATED
        Filter results to those created on or before a certain date

    .PARAMETER QUERY
        Perform a generic substring search across all fields

    .PARAMETER LIMIT
        The maximum records to return [default: 100]

    .PARAMETER OFFSET
        The offset to start retrieving records from [default: 0]

    .PARAMETER ALL
        Repeat request until all results are returned
#>
    [CmdletBinding()]
    [OutputType([psobject])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('snort-suricata-master','snort-suricata-update', 'snort-suricata-changelog',
        'yara-master', 'yara-update', 'yara-changelog', 'common-event-format', 'netwitness')]
        [string]
        $Type,

        [array]
        $Name,

        [array]
        $Description,

        [array]
        $Tag,

        [datetime]
        $MinCreated,

        [datetime]
        $MaxCreated,

        [string]
        $Query,

        [ValidateRange(1,100)]
        [int]
        $Limit = 100,

        [int]
        $Offset = 0,

        [switch]
        $All
    )
    process{
        $Param = @{
            Uri = '/intel/queries/rules/v1?type=' + $Type + '&limit=' + [string] $Limit +
            '&offset=' + [string] $Offset
            Method = 'get'
            Header = @{
                accept = 'application/json'
                'content-type' = 'application/json'
            }
        }
        switch ($PSBoundParameters.Keys) {
            'Name' { $Param.Uri += ('&name=' + ($Name -join '&name=')) }
            'Description' { $Param.Uri += ('&description=' + ($Description -join '&description=')) }
            'Tag' { $Param.Uri += ('&tags=' + ($Tag -join '&tags=')) }
            'Query' { $Param.Uri += '&q=' + $Query }
            'Verbose' { $Param['Verbose'] = $true }
            'Debug' { $Param['Debug'] = $true }
        }
        if ($All) {
            Join-CsResult -Activity $MyInvocation.MyCommand.Name -Param $Param
        }
        else {
            Invoke-CsAPI @Param
        }
    }
}