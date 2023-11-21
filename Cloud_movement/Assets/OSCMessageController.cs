using UnityEngine;
using extOSC;
using System.Collections.Generic;

public class OSCMessageController : MonoBehaviour
{
    public CloudManager cloudManager;
    private OSCReceiver receiver;
    private float xDir;

    protected virtual void Awake()
    {
        // Create OSC receiver and set the port number
        receiver = GetComponent<OSCReceiver>();
        receiver.LocalPort = 7001;
        receiver.Bind("/xdir", ReceivedXDir);
        receiver.Bind("/pattern", ReceivedPattern);
        receiver.Connect();
    }

    protected virtual void Start()
    {
    }

    protected virtual void Update()
    {
        cloudManager.UpdateCloud(xDir);
    }

    private void ReceivedXDir(OSCMessage message)
	{
        // Extract the value from the OSC message
        xDir = message.Values[0].FloatValue;
    }

    private void ReceivedPattern(OSCMessage message)
	{
        
    }
}